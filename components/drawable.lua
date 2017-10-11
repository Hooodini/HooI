local DrawableComponent = HooI.component.create("DrawableComponent")

function DrawableComponent:initialize(...)
	HooI.initComponent(self, {
		{name = "drawable", varType = {"Image", "Animation"} }, 
		{name = "layer", varType = "number"},
		{name = "x", varType = "number"},
		{name = "y", varType = "number"},
		{name = "w", varType = "number"},
		{name = "h", varType = "number"},
	}, ...)

	self.sx = nil
	self.sy = nil
end

return DrawableComponent