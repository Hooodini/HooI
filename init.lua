folderPath = ... .. "."

local HooECS = require (folderPath .. "lib.HooECS")
HooECS.initialize({
    globals = false,
    debug = true
    })

-- Setup HooECS stuff
local HooI = {}
HooI.entity = HooECS.Entity
HooI.component = HooECS.Component
HooI.system = HooECS.System
HooI.engine = HooECS.Engine
HooI.class = HooECS.class
HooI.eventManager = HooECS.EventManager

-- Setup Systems
HooI.systems = {} 
HooI.systems.WidgetDrawSystem = require(folderPath .. "systems.WidgetDrawSystem")(HooI)
HooI.systems.HoverUpdateSystem = require(folderPath .. "systems.HoverUpdateSystem")(HooI)
HooI.systems.ClickSystem = require(folderPath .. "systems.ClickSystem")(HooI)
HooI.systems.TooltipSystem = require(folderPath .. "systems.TooltipSystem")(HooI)
HooI.systems.DrawableDrawSystem = require(folderPath .. "systems.DrawableDrawSystem")(HooI)
HooI.systems.ButtonSystem = require(folderPath .. "systems.ButtonSystem")(HooI)
HooI.systems.SelectableSystem = require(folderPath .. "systems.SelectableSystem")(HooI)
HooI.systems.ManipulatableSystem = require(folderPath .. "systems.ManipulatableSystem")(HooI)

-- Init Components
local widgetComponent = require(folderPath .. "components.WidgetComponent")(HooI)
HooI.hoverable = require(folderPath .. "components.HoverableComponent")(HooI)
HooI.clickable = require(folderPath .. "components.ClickableComponent")(HooI)
HooI.drawable = require(folderPath .. "components.DrawableComponent")(HooI)
HooI.tooltip = require(folderPath .. "components.TooltipComponent")(HooI)
HooI.button = require(folderPath .. "components.ButtonComponent")(HooI)
HooI.selectable = require(folderPath .. "components.SelectableComponent")(HooI)
HooI.manipulatable = require(folderPath .. "components.ManipulatableComponent")(HooI)

-- Init Events
HooI.events = {}
HooI.events.MousePressedEvent = require(folderPath .. "events.MousePressedEvent")(HooI)
HooI.events.MouseReleasedEvent = require(folderPath .. "events.MouseReleasedEvent")(HooI)
HooI.events.HoverEvent = require(folderPath .. "events.HoverEvent")(HooI)
HooI.events.ClickEvent = require(folderPath .. "events.ClickEvent")(HooI)
HooI.events.SelectionEvent = require(folderPath .. "events.SelectionEvent")(HooI)
HooI.events.KeyInputEvent = require(folderPath .. "events.KeyInputEvent")(HooI)

-- Returns either middleclass name or generic type.
HooI.utils = {}
HooI.utils.type = function(object)
    if type(object) == "table" then
        if object.class then
            return object.class.name
        else
            return type(object)
        end
    else
        return type(object)
    end
end

HooI.canvas = require(folderPath .. "canvas")(HooI);

-- Prepares table compatible with middleclass
-- Implements the __call metamethod only for callbacks for conveninet callback functions that aren't directly to a function
HooI.utils.callbackMetatable = {}
HooI.utils.callbackMetatable.__call = function(t, ...) t.table[t.func](t.table, ...) end

-- Util function for component variable initialization. Ugly but the resulting component creation and custom component writing is amazing!
-- Also holy shit this is one long ass function :'D
HooI.initComponent = function(component, entries, ...)
    local addVariable = function(component, entry, var)
        if type(entry["varType"]) == "table" then
            local valid = false
            for _, varType in ipairs(entry["varType"]) do
                local loveType
                if type(var) == "userdata" then
                    loveType = var:type()
                end
                if type(var) == varType or HooI.utils.type(var) == varType or loveType == varType then
                    component[entry["name"]] = var
                    valid = true
                end
            end
            if not valid then
                varTypeString = ""
                for _, varType in ipairs(entry["varType"]) do
                    varTypeString = varTypeString .. " " .. varType
                end
                expectedType = HooI.utils.type(var)
                if type(var) == "userdata" then
                    expectedType = var:type()
                end
                error(component.class.name .. " initialization error. \"" .. entry["name"] .. "\" received wrong variable. \"" .. varTypeString .. " \" expected. Got \"" .. expectedType .. "\"") --, 4)
            end
        else
            local loveType
            if type(var) == "table" then
                if var.type then
                    loveType = var:type()
                end
            end
            if type(var) == varType or HooI.utils.type(var) == varType or loveType == varType then
                component[entry["name"]] = var
                valid = true
            else
                expectedType = HooI.utils.type(var)
                if type(var) == "userdata" then
                    expectedType = var:type()
                end
                error(component.class.name .. " initialization error. \"" .. entry["name"] .. "\" received wrong variable. \"" .. type(entry["varType"]) .. " \" expected. Got \"" .. expectedType .. "\"") --, 4)  
            end
        end
    end

    args = {...}
    -- If there are any args
    if args[1] then
        -- [1] Special case handling if the parameter was a single table. Dirty but will now behave as expected.
        local listOfInts = false
        ::redo::

        -- If args are a list of variables (will misbehave if a table is the only parameter)
        if #args > 1 or type(args[1]) ~= "table" or listOfInts then

            -- args is a list of integers
            for k, v in ipairs(entries) do
                if args[k] then
                    addVariable(component, v, args[k])
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
            for k, v in ipairs(entries) do
                if args[v["name"]] then
                    addVariable(component, v, args[k])
                else
                    if v["default"] then
                        component[v["name"]] = v["default"]
                    end
                end
            end
        end 
    else
        -- If no args were passed, initialize with default values.
        for _, entry in ipairs(entries) do
            if entry["default"] then
                component[entry["name"]] = entry["default"]
            end
        end
    end
end

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
function HooI:mousePressed(x, y, button)
    for i = #self.activeCanvases, 1, -1 do
        return self.activeCanvases[i]:mousePressed(x, y, button)
    end
end

-- Return after the first widget used this event.
function HooI:mouseReleased(x, y, button)
    for i = #self.activeCanvases, 1, -1 do
        return self.activeCanvases[i]:mouseReleased(x, y, button)
    end
end

-- The love callback is lowercase. All function and variable names in this library will be lower camel case.
-- But to be more user friendly, the original names will be made available too. 
HooI.mousepressed = HooI.mousePressed
HooI.mousereleased = HooI.mouseReleased

--[[ Intended input types:
    up
    down
    left
    right
    press
    execute
    Returns after the first canvas used this event ]]
function HooI:keyInput(inputType)
    for i = #self.activeCanvases, 1, -1 do
        return self.activeCanvases[i]:keyInput(inputType)
    end
end

function HooI:addSystem(newSystem)
    if newSystem.super then
        if newSystem.super.name then
            if newSystem.super.name == "System" then
                if not self.systems[newSystem.name] then
                    self.systems[newSystem.name] = newSystem
                else
                    print("Attempting to add system with the same name as an existing system. Ignoring the addition.")
                end
            end
        end
    end
end

-- Canvas setup
HooI.canvases = {};
HooI.activeCanvases = {};

function HooI:activateCanvas(canvas, index)
    if not canvas.class.name == "Canvas" then
        print("HooI:activate canvas error: Provided canvas is not of class \"Canvas\"!")
        return
    end

    -- Don't add the same canvas multiple times
    for _, c in pairs(self.activeCanvases) do
        if c == canvas then
            return
        end
    end

    for _, c in pairs(self.canvases) do
        if c == canvas then
            if type(index) == "number" then
                table.insert(self.activeCanvases, index, canvas)
            else
                table.insert(self.activeCanvases, canvas)
            end
            canvas.active = true
            return true
        end
    end
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

function HooI:newTooltip(w, h)
    local entity = HooI.entity()
    entity:add(widgetComponent(0, 0, w, h))
    return entity
end

function HooI:newAnimation(image, quads, duration)
    local animation = HooI.class("Animation")
    animation.image = image
    animation.quads = quads
    animation.duration = duration or 1
    animation.currentTime = 0
    return animation
end

function HooI:newCallback(table, func)
    if type(table) == "table" and type(func) == "function" then
        local callback = HooI.class("Callback")
        setmetatable(callback, HooI.utils.callbackMetatable)
        callback.table = table
        callback.func = func

        return callback
    else 
        error("Trying to create callback table invalid parameters. Should be table, function. Is " .. type(table) .. ", " .. type(func))
    end
end

function HooI:newManipulator(componentName, varName, func)
    if not type(componentName) == "string" then
        print("[!] HooI:newManipulator error! componentName is not a string!")
    end
    if not type(varName) == "string" then
        print("[!] HooI:newManipulator error! varName is not a string!")
    end

    local newManipulator = {}
    newManipulator.component = componentName
    newManipulator.var = varName
    newManipulator.func = func

    return newManipulator
end

-- Keep HooI global for initialization
-- But remove from global scope afterwards

return HooI
