local HoverableComponent = HooI.component.create("HoverableComponent")

function HoverableComponent:initialize(enterCallback, leaveCallback, layer, x, y, w, h)
    self.enterCallback = enterCallback or function() print("enter") end
    self.leaveCallback = leaveCallback or function() print("leave") end
    self.layer = layer or 1
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.hovered = false
end

function HoverableComponent:unload()
	if self.hovered then
		self.hovered = false
		self.leaveCallback()
	end
end

return HoverableComponent