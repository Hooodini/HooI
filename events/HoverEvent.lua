local HoverEvent = HooI.class("HoverEvent")

function HoverEvent:initialize(entity, isHovered)
	self.entity = entity
    self.isHovered = isHovered
end

return HoverEvent
