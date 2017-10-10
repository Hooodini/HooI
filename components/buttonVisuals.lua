local ButtonComponent = HooI.component.create("ButtonComponent")

function ButtonComponent:initialize(...)
	HooI.initComponent(self, {
		{name = "normalDrawable", varType = {"userdata", "Animation"} }, 
		{name = "hoverDrawable", varType = {"userdata", "Animation"} }, 
		{name = "clickDrawable", varType = {"userdata", "Animation"} }, 
		{name = "button", varType = "number", default = 1}
	}, ...)

	-- Will be added by the drawSystem
	self.sx = nil
	self.sy = nil
end

return ButtonComponent
