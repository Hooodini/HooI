local HooI

return function(lib)
    HooI = lib
    local TooltipComponent = HooI.component.create("TooltipComponent")

    function TooltipComponent:initialize(...)
        HooI.initComponent(self, {
            {name = "widget", varType = "Entity"}, 
        }, ...)
        
        self.init = false
    end

    return TooltipComponent
end
