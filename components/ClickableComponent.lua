local ClickableComponent = HooI.component.create("ClickableComponent")

function ClickableComponent:initialize(...)
	HooI.initComponent(self, {
		{name = "clickCallback", varType = "function", default = function() print("click") end}, 
		{name = "layer", varType = "number", default = 1},
		{name = "x", varType = "number", default = 0},
		{name = "y", varType = "number", default = 0},
		{name = "w", varType = "number", default = 0},
		{name = "h", varType = "number", default = 0},
	}, ...)

	self.pressed = false
end

return ClickableComponent
