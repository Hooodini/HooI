local CanvasModeEvent = HooI.class("CanvasModeEvent")

function CanvasModeEvent:initialize(newMode)
    self.mode = newMode
end

return CanvasModeEvent
