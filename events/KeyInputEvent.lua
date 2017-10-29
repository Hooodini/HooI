return function(HooI)
    local KeyInputEvent = HooI.class("KeyInputEvent")

    function KeyInputEvent:initialize(inputType)
    	self.inputType = inputType
    end

    return KeyInputEvent
end
