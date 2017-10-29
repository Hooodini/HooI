local HooI

return function(lib)
	HooI = lib
	local ButtonComponent = HooI.component.create("ButtonComponent")

	function ButtonComponent:initialize(...)
		HooI.initComponent(self, {
			{name = "normalDrawable", varType = {"Image", "Animation"} }, 
			{name = "hoverDrawable", varType = {"Image", "Animation"} }, 
			{name = "clickDrawable", varType = {"Image", "Animation"} }, 
			{name = "button", varType = "number", default = 1}
		}, ...)

		self.current = self.normalDrawable

		-- Will be added by the drawSystem
		self.sx = nil
		self.sy = nil
	end

	return ButtonComponent
end
