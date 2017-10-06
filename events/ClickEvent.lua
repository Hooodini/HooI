local ClickEvent = HooI.class("ClickEvent")

function ClickEvent:initialize(button, isPressed)
    self.button = button
    self.isPressed = isPressed
end

return ClickEvent
