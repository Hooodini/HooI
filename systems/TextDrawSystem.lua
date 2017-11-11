local HooI

return function(lib)
    HooI = lib
    local TextDrawSystem = HooI.class("TextDrawSystem", HooI.system)

    function TextDrawSystem:draw()
        local wc, tc
        for k, entity in pairs(self.targets) do
            wc = entity:get("WidgetComponent")
            tc = entity:get("TextComponent")

            love.graphics.print(tc.string, wc.x + tc.dx, wc.y + tc.dy)
        end
    end

    function TextDrawSystem:requires()
        return {"WidgetComponent", "TextComponent"}
    end

    return TextDrawSystem
end
