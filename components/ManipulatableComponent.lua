local HooI

return function(lib)
    HooI = lib
    local ManipulatableComponent = HooI.component.create("ManipulatableComponent")
    -- Manipulators consist of the following keys:
    --      component (string) - The component name that should be manipulated
    --      var (string) - The variable key to be manipulated
    --      func (function) - Returning which should be set on update. 
    function ManipulatableComponent:initialize(listOfManipulators)
        self.manipulators = listOfManipulators
    end

    return ManipulatableComponent
end
