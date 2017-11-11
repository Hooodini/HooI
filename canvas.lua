local HooI

return function(lib)
    HooI = lib
    local Canvas = HooI.class("Canvas")

    function Canvas:initialize(canvasName, active, systems, inputMode)
        self.canvasName = canvasName or "GenericCanvas"
        self.engine = HooI.engine()
        self.eventManager = self.engine.eventManager

        -- ToDo Add Systems

        self.widgets = {}
        self.active = active or true
        self.mode = inputMode or "mouse"

        if type(systems) == "table" then
            for _, v in pairs(systems) do
                if HooI.systems[v] then
                    self:addSystem(HooI.systems[v])
                end
            end
        end
    end

    function Canvas:update(dt)
        self.engine:update(dt)
    end

    function Canvas:draw()
        love.graphics.push()
            if self.scissor then
                love.graphics.setScissor(unpack(self.scissor))
            end
            if self.translate then
                love.graphics.translate(unpack(self.translate))
            end
            self.engine:draw()
            love.graphics.setScissor()
        love.graphics.pop()
    end

    function Canvas:setScissor(x, y, w, h)
        if x and y and w and h then
            self.scissor = {x, y, w, h}
        else
            self.scissor = nil
        end
    end

    function Canvas:translate(x, y)
        if x and y then
            self.translate = {x, y}
        else
            self.translate = nil
        end
    end

    function Canvas:mousePressed(x, y, button)
        return self.eventManager:fireEvent(HooI.events.MousePressedEvent(x, y, button))
    end

    function Canvas:mouseReleased(x, y, button)
        return self.eventManager:fireEvent(HooI.events.MouseReleasedEvent(x, y, button))
    end

    function Canvas:keyInput(inputType)
        return self.eventManager:fireEvent(HooI.events.KeyInputEvent(inputType))
    end

    function Canvas:add(newWidget)
        -- ToDo check newWidget type
        self.engine:addEntity(newWidget)
    end

    function Canvas:remove(widget, removeChildren)
        -- ToDo check widget type
        self.engine:removeEntity(widget, removeChildren)
    end

    function Canvas:addSystem(newSystem)
        -- ToDo check newSystem type
        self.engine:addSystem(newSystem(self))
    end

    function Canvas:startSystem(system)
        -- ToDo check system type
        self.engine:startSystem(system)
    end

    function Canvas:stopSystem(system)
        -- ToDo check system type
        self.engine:stopSystem(system)
    end

    function Canvas:toggleSystem(system)
        -- ToDo check system type
        self.engine:toggleSystem(system)
    end

    -- self.active will be updated by activateCanvas / deactivateCanvas
    function Canvas:activate(index)
        HooI:activateCanvas(self, index)
    end

    function Canvas:deactivate()
        HooI:deactivateCanvas(self)
    end

    function Canvas:activateWidget(widget)
        -- ToDo Check widget type
        widget:get("WidgetComponent").active = true
        self.eventManager:fireEvent(ActivationEvent(widget, true))
    end

    function Canvas:deactivateWidget(widget)
        -- ToDo Check widget type
        widget:get("WidgetComponent").active = false
        self.eventManager:fireEvent(ActivationEvent(widget, false))
    end

    return Canvas
end
