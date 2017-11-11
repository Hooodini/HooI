local HooI

return function(lib)
    HooI = lib
    local ClickableComponent = HooI.component.create("ClickableComponent")

    function ClickableComponent:initialize(...)
        HooI.initComponent(self, {
            {name = "executedCallback", varType = "function", default = function() print("click") end}, 
            {name = "layer", varType = "number", default = 1},
            {name = "dx", varType = "number", default = 0},
            {name = "dy", varType = "number", default = 0},
            {name = "dw", varType = "number", default = 0},
            {name = "dh", varType = "number", default = 0},
        }, ...)

        self.pressed = false
    end

    return ClickableComponent
end
