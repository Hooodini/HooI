local HoverableComponent = HooI.component.create("HoverableComponent")

function HoverableComponent:initialize(...)
	HooI.initComponent(self, {
		{name = "enterCallback", varType = "function", default = function() end}, 
		{name = "leaveCallback", varType = "function", default = function() end},
		{name = "layer", varType = "number", default = 1},
		{name = "x", varType = "number"},
		{name = "y", varType = "number"},
		{name = "w", varType = "number"},
		{name = "h", varType = "number"},
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