folderPath = ... .. "."

local lovetoys = require (folderPath .. "lib.HooECS.lovetoys")
lovetoys.initialize({
	globals = false,
	debug = true
	})

-- Setup Lovetoys stuff
HooI = {}
HooI.entity = lovetoys.Entity
HooI.component = lovetoys.Component
HooI.system = lovetoys.System
HooI.engine = lovetoys.Engine
HooI.class = lovetoys.class
HooI.eventManager = lovetoys.EventManager

-- Util function for component variable initialization. Ugly but the resulting component creation and custom component writing is amazing!
HooI.initComponent = function(component, entries, ...)
	args = {...}
	-- If there are any args
	if args[1] then
		-- [1] Special case handling if the parameter was a single table. Dirty but will now behave as expected.
		local listOfInts = false
		::redo::

		-- If args are a list of variables (will misbehave if a table is the only parameter)
		if #args > 1 or type(args[1]) ~= "table" or listOfInts then

			-- args is a list of integers
			for k, v in pairs(entries) do
				if args[k] then
					if type(args[k]) == v["varType"] then
						component[v["name"]] = args[k]
					else
						error(component.class.name .. " initialization error. \"" .. v["name"] .. "\" received wrong variable. \"" .. v["varType"] .. "\" expected. Got \"" .. type(args[k]) .. "\"", 4)
					end
				else
					if v["default"] then
						component[v["name"]] = v["default"]
					end
				end
			end
		else
			-- [2] Special case handling if the parameter was a single table. Dirty but will now behave as expected.
			if args[1][1] then
				if args[1][1].name and args[1][1].varType then
					listOfInts = true
					goto redo
				end
			end
			args = args[1]
			-- args is a list of strings
			for k, v in pairs(entries) do
				if args[v["name"]] then
					if type(args[v["name"]]) == v["varType"] then
						component[v["name"]] = args[v["name"]]
					else
						error(component.class.name .. " initialization error. \"" .. v["name"] .. "\" received wrong variable. \"" .. v["varType"] .. "\" expected. Got \"" .. type(args[k]) .. "\"", 4)
					end
				else
					if v["default"] then
						component[v["name"]] = v["default"]
					end
				end
			end
		end	
	else
		-- If no args were passed, initialize with default values.
		for _, entry in pairs(entries) do
			if entry["default"] then
				component[entry["name"]] = entry["default"]
			end
		end
	end
end

-- Setup Systems
HooI.systems = {} 
HooI.systems.WidgetDrawSystem = require(folderPath .. "systems.widgetDrawSystem")
HooI.systems.HoverUpdateSystem = require(folderPath .. "systems.hoverUpdateSystem")
HooI.systems.ClickSystem = require(folderPath .. "systems.clickSystem")

-- Init Components
local widgetComponent = require(folderPath .. "components.widgetComponent")
HooI.hoverable = require(folderPath .. "components.hoverable")
HooI.clickable = require(folderPath .. "components.clickable")
HooI.drawable = require(folderPath .. "components.drawable")

-- Init Events

HooI.events.MousePressed = require(folderPath .. "events.MousePressed")
HooI.events.MouseReleased = require(folderPath .. "events.MouseReleased")

-- Canvas setup
HooI.canvases = {};
HooI.activeCanvases = {};

-- HooI interface
function HooI:update(dt)
	for _, canvas in ipairs(self.activeCanvases) do
		canvas:update(dt)
	end
end

function HooI:draw()
	for _, canvas in ipairs(self.activeCanvases) do
		canvas:draw()
	end
end

-- Return after the first widget used this event.
function HooI:mousePressed(button, x, y)
	for i = #self.activeCanvases, 1, -1 do
		local val = self.activeCanvases[i]:mousePressed(x, y, button)
		if val then
			return val
		end
	end
end

-- Return after the first widget used this event.
function HooI:mouseReleased(button, x, y)
	for i = #self.activeCanvases, 1, -1 do
		local val = self.activeCanvases[i]:mouseReleased(x, y, button)
		if val then
			return val
		end
	end
end

-- The love callback is lowercase. All function and variable names in this library will be lower camel case.
-- But to be more user friendly, the original names will be made available too. 
HooI.mousepressed = HooI.mousePressed
HooI.mousereleased = HooI.mouseReleased

function HooI:addSystem(newSystem)
	if newSystem.super then
		if newSystem.super.name then
			if newSystem.super.name == "System" then
				if not self.systems[newSystem.name] then
					self.systems[newSystem.name] = newSystem
				else
					print("Attempting to add a system that already exists (or has the same name as an existing system)")
				end
			end
		end
	end
end

function HooI:activateCanvas(canvas)
	if not canvas.class.name == "Canvas" then
		print("HooI:activate canvas error: Provided canvas is not of class \"Canvas\"!")
		return
	end

	-- Don't add the same canvas multiple times
	for _, c in pairs(self.canvases) do
		if c == canvas then
			return
		end
	end

	table.insert(self.activeCanvases, canvas)
	canvas.active = true

	return true
end

function HooI:deactivateCanvas(canvas)
	if not canvas.class.name == "Canvas" then
		print("HooI:deactivate canvas error: Provided canvas is not of class \"Canvas\"!")
		return
	end

	for k, c in pairs(self.activeCanvases) do
		if c == canvas then
			table.remove(self.activeCanvases, k)
			canvas.active = false
			return true
		end
	end
end

function HooI:activateCanvasByName(name)
	for _, canvas in pairs(self.canvases) do
		if canvas.canvasName == name then
			return self:activateCanvas(canvas)
		end
	end
end

function HooI:deactivateCanvasByName(name)
	for _, canvas in pairs(self.activeCanvases) do
		if canvas.canvasName == name then
			return self:deactivateCanvas(canvas)
		end
	end
end

HooI.canvas = require(folderPath .. "canvas");

function HooI:newCanvas(name, active, systems)
	local canvas = HooI.canvas(name, active, systems)

	table.insert(self.canvases, canvas)
	if canvas.active then
		table.insert(self.activeCanvases, canvas)
	end
	return canvas
end

function HooI:newWidget(x, y, w, h)
	local entity = HooI.entity()
	entity:add(widgetComponent(x, y, w, h))
	return entity
end

-- Keep HooI global for initialization
-- But remove from global scope afterwards
local h = HooI
HooI = nil

return h
