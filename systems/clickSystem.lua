local HooI

return function(lib)
    HooI = lib
    local ClickSystem = HooI.class("ClickSystem", HooI.system)

    function ClickSystem:initialize(canvas)
        self.class.super.initialize(self)
        self.layers = {}

        canvas.eventManager:addListener("MousePressed", self, self.mouseEvent)
        canvas.eventManager:addListener("MouseReleased", self, self.mouseEvent)
    end

    function ClickSystem:onAddEntity(entity)
        local cc = entity:get("ClickableComponent")
        if not self.layers[cc.layer] then
            for i=#self.layers + 1, cc.layer do
                self.layers[i] = {}
            end
        end
        table.insert(self.layers[cc.layer], entity)
    end

    function ClickSystem:onRemoveEntity(entity)
        for _, layer in pairs(self.layers) do
            for k, e in pairs(layer) do
                if e == entity then
                    table.remove(layer, k)
                end
            end
        end
    end

    function ClickSystem:mouseEvent(event)
        local wc, cc, x, y, w, h
        for i = #self.layers, 1, -1 do
            for _, entity in pairs(self.layers[i]) do
                wc = entity:get("WidgetComponent")
                cc = entity:get("ClickableComponent")

                x = wc.x + cc.dx
                y = wc.y + cc.dy
                w = wc.w + cc.dw
                h = wc.h + cc.dh

                if x < event.x and x + w > event.x and y < event.y and y + h > event.y then
                    if event.class.name == "MousePressed" then
                        cc.pressed = true
                        entity.eventManager:fireEvent(HooI.events.ClickEvent(entity, event.button, true))
                        return true
                    elseif event.class.name == "MouseReleased" then
                        if cc.pressed then
                            cc.pressed = false
                            if not entity.eventManager:fireEvent(HooI.events.ClickEvent(entity, event.button, false)) then
                                if cc.clickCallback then
                                    cc:clickCallback(entity)
                                end
                            end
                        end
                        return true
                    end
                end
            end
        end
    end 

    function ClickSystem:requires()
        return {"WidgetComponent", "ClickableComponent"}
    end

    return ClickSystem
end
