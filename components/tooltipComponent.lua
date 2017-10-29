local HooI

return function(lib)
    HooI = lib
    local TooltipComponent = HooI.component.create("TooltipComponent")

    function TooltipComponent:initialize(tooltipWidget)
        self.widget = tooltipWidget
        self.init = false
    end

    return TooltipComponent
end
