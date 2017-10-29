return function(HooI)
    local ClickEvent = HooI.class("ClickEvent")

    function ClickEvent:initialize(entity, button, isPressed)
    	self.entity = entity
        self.button = button
        self.isPressed = isPressed
    end

    return ClickEvent
end
