local HooI

return function(lib)
    HooI = lib
    local ManipulatableSystem = HooI.class("ManipulatableSystem", HooI.system)

    function ManipulatableSystem:update(dt)
        local mc, newVar

        for k, entity in pairs(self.targets) do
            mc = entity:get("ManipulatableComponent")
            if entity:get(mc.component) then
                if entity:get(mc.component)[mc.var] then
                    newVar = mc.func(dt)
                    if newVar then
                        entity:get(mc.component)[mc.var] = newVar
                    else
                        
                    end
                end
            end
        end
    end

    function ManipulatableSystem:requires()
        return {"WidgetComponent", "ManipulatableComponent"}
    end

    return ManipulatableSystem
end
