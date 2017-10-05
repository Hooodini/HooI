local ClickableComponent = HooI.component.create("ClickableComponent")

function ClickableComponent:initialize(...)
	HooI.initComponent(self, {
		{name = "clickCallback", varType = "function", default = function() print("click") end}, 
		{name = "layer", varType = "number", default = 1},
		{name = "x", varType = "number"},
		{name = "y", varType = "number"},
		{name = "w", varType = "number"},
		{name = "h", varType = "number"},
	}, ...)

	pressed = false
end

return ClickableComponent
