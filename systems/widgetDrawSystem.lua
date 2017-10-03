local WidgetDrawSystem = HooI.class("WidgetDrawSystem", HooI.system)

function WidgetDrawSystem:draw()
    for k, entity in pairs(self.targets) do
        local wc = entity:get("WidgetComponent")
        love.graphics.rectangle("fill", wc.x, wc.y, wc.w, wc.h)
    end
end

function WidgetDrawSystem:requires()
    return {"WidgetComponent"}
end

return WidgetDrawSystem