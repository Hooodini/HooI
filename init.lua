folderPath = ... .. "."

local lovetoys = require (folderPath .. "lib.HooECS.lovetoys")
lovetoys.initialize({
	globals = false,
	debug = true
	})

-- Setup Lovetoys stuff
HooI = {}
HooI.entity = lovetoys.Entity;
HooI.component = lovetoys.Component;
HooI.system = lovetoys.System;
HooI.engine = lovetoys.Engine;
HooI.class = lovetoys.class;

HooI.initComponent = function(component, entries, ...)
	args = {...}
	if args[1] then
		if #args > 1 or type(args[1]) ~= "table" then
			-- Integer entries.
			for k, v in pairs(entries) do
				if args[k] then
					if type(args[k]) == v["varType"] then
						component[v["name"]] = args[k]
					else
						print(component.class.name .. " initialization error. \"" .. v["name"] .. "\" received wrong variable. \"" .. v["varType"] .. "\" expected. Got \"" .. type(args[k]) .. "\"")
					end
				else
					if v["default"] then
						component[v["name"]] = v["default"]
					end
				end
			end
		else
			args = args[1]
			-- String entries
			for k, v in pairs(entries) do
				if args[v["name"]] then
					if type(args[v["name"]]) == v["varType"] then
						component[v["name"]] = args[v["name"]]
					else
						print(component.class.name .. " initialization error. \"" .. v["name"] .. "\" received wrong variable. \"" .. v["varType"] .. "\" expected. Got \"" .. type(args[k]) .. "\"")
					end
				else
					if v["default"] then
						component[v["name"]] = v["default"]
					end
				end
			end
		end	
	else
		for _, entry in pairs(entries) do
			if entry["default"] then
				component[entry["name"]] = entry["default"]
			end
		end
	end
end

-- Setup Systems
HooI.systems = {} 
HooI.systems.widgetDrawSystem = require(folderPath .. "systems.widgetDrawSystem")
HooI.systems.hoverUpdateSystem = require(folderPath .. "systems.hoverUpdateSystem")

-- Init Components
local widgetComponent = require(folderPath .. "components.widgetComponent")
HooI.hoverable = require(folderPath .. "components.hoverable")
HooI.clickable = require(folderPath .. "components.clickable")
HooI.drawable = require(folderPath .. "components.drawable")

HooI.canvases = {};
HooI.activeCanvases = {};

function HooI:update(dt)
	for _, canvas in pairs(self.activeCanvases) do
		canvas:update(dt)
	end
end

function HooI:draw()
	for _, canvas in pairs(self.activeCanvases) do
		canvas:draw()
	end
end

function HooI:activateCanvasByName(name)
	local updated = 0
	local notUpdated = 0
	for _, canvas in pairs(self.canvases) do
		if canvas.canvasName == name then
			if canvas.active then
				notUpdated = notUpdated + 1
			else
				canvas:activate()
				updated = updated + 1
			end
		end
	end
	return updated, notUpdated
end

function HooI:deactivateCanvasByName(name)
	local updated = 0
	local notUpdated = 0
	for _, canvas in pairs(self.canvases) do
		if canvas.canvasName == name then
			if not canvas.active then
				notUpdated = notUpdated + 1
			else
				canvas:deactivate()
				updated = updated + 1
			end
		end
	end
	return updated, notUpdated
end

HooI.canvas = require(folderPath .. "canvas");

function HooI:newCanvas(name, active, systems)
	local canvas = HooI.canvas(name, active)
	canvas:addSystem(HooI.systems.widgetDrawSystem())
	canvas:addSystem(HooI.systems.hoverUpdateSystem())
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
