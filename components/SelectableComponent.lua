local HooI

return function(lib)
    HooI = lib
    local SelectableComponent = HooI.component.create("SelectableComponent")

    function SelectableComponent:initialize(...)
    	HooI.initComponent(self, {
    		{name = "up", varType = "Entity"}, 
    		{name = "down", varType = "Entity"}, 
    		{name = "left", varType = "Entity"}, 
    		{name = "right", varType = "Entity"}
    	}, ...)

    	self.selected = false
    	self.pressed = false
    end

    return SelectableComponent
end
