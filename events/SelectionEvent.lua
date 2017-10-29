return function(HooI)
    local SelectionEvent = HooI.class("SelectionEvent")

    function SelectionEvent:initialize(entity, selected, pressed, released)
    	self.entity = entity
        self.selected = selected
        self.pressed = pressed
        self.released = released
    end

    return SelectionEvent
end
