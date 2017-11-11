local HooI

return function(lib)
    HooI = lib
    local WidgetComponent = HooI.component.create("WidgetComponent")

    function WidgetComponent:initialize(...)
        HooI.initComponent(self, {
            {name = "x", varType = "number", default = 0}, 
            {name = "y", varType = "number", default = 0}, 
            {name = "w", varType = "number", default = 50}, 
            {name = "h", varType = "number", default = 50}
        }, ...)
    end

    return WidgetComponent
end
