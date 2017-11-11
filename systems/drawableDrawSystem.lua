local HooI

return function(lib)
    HooI = lib
    local DrawableDrawSystem = HooI.class("DrawableDrawSystem", HooI.system)

    function DrawableDrawSystem:draw()
        local wc, dc, x, y, w, h
        for k, entity in pairs(self.targets) do
            wc = entity:get("WidgetComponent")
            dc = entity:get("DrawableComponent")

            x = wc.x + dc.dx
            y = wc.y + dc.dy

            if not dc.sx then
                w = wc.w + dc.dw
                dc.sx = w / dc.drawable:getWidth()
            end
            if not dc.sy then
                h = wc.h + dc.dh
                dc.sy = h / dc.drawable:getHeight()
            end

            love.graphics.draw(dc.drawable, x, y, 0, dc.sx, dc.sy)
        end
    end

    function DrawableDrawSystem:requires()
        return {"WidgetComponent", "DrawableComponent"}
    end

    return DrawableDrawSystem
end
