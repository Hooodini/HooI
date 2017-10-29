local HooI

return function(lib)
    HooI = lib
	local HoverableComponent = HooI.component.create("HoverableComponent")

	function HoverableComponent:initialize(...)
		HooI.initComponent(self, {
			{name = "enterCallback", varType = "function", default = function() end}, 
			{name = "leaveCallback", varType = "function", default = function() end},
			{name = "layer", varType = "number", default = 1},
			{name = "x", varType = "number", default = 0},
			{name = "y", varType = "number", default = 0},
			{name = "w", varType = "number", default = 0},
			{name = "h", varType = "number", default = 0},
			{name = "cursor", varType = "Cursor", default = love.mouse.getSystemCursor("hand")}
		}, ...)

		self.hovered = false
	end

	function HoverableComponent:unload()
		if self.hovered then
			self.hovered = false
			self.leaveCallback()
		end
	end

	return HoverableComponent
end
