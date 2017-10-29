local HooI

return function(lib)
    HooI = lib
    local TooltipSystem = HooI.class("TooltipSystem", HooI.system)

    function TooltipSystem:initialize(canvas)
        self.class.super.initialize(self)
        
        canvas.eventManager:addListener("HoverEvent", self, self.hoverEvent)
    end

    function TooltipSystem:onAddEntity(entity)
        ttc = entity:get("TooltipComponent")
        if not ttc.init then
            ttc.init = true
            entity:getEngine():addEntity(ttc.widget)
            ttc.widget:deactivate()
        end
    end

    function TooltipSystem:update(dt)
        for k, entity in pairs(self.targets) do
            print("Entity", entity.components)
            for k, v in pairs(entity.components) do
                print(k, v)
            end
            local ttw = entity:get("TooltipComponent").widget
            if ttw.active then
                local mx, my = love.mouse.getPosition()
                wc = ttw:get("WidgetComponent")
                wc.x = mx - (wc.w / 2)
                wc.y = my - (wc.h + 5)
            end
        end
    end

    function TooltipSystem:hoverEvent(event)
        local ttc = event.entity:get("TooltipComponent")
        if ttc then
            if event.isHovered then
                ttc.widget:activate()
            else
                ttc.widget:deactivate()
            end
        end
    end

    function TooltipSystem:requires()
        return {"WidgetComponent", "TooltipComponent"}
    end

    return TooltipSystem
end
