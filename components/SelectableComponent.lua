local HooI

return function(lib)
    HooI = lib
    local SelectableComponent = HooI.component.create("SelectableComponent")

    function SelectableComponent:initialize(...)
        HooI.initComponent(self, {
            {name = "up", varType = "Entity"}, 
            {name = "down", varType = "Entity"}, 
            {name = "left", varType = "Entity"}, 
            {name = "right", varType = "Entity"},
            {name = "selectedCallback", varType = {"function", "Callback"}, default = function() end},
            {name = "deselectedCallback", varType = {"function", "Callback"}, default = function() end},
            {name = "executedCallback", varType = {"function", "Callback"}, default = function() end}
        }, ...)

        self.selected = false
        self.pressed = false
    end

    return SelectableComponent
end
