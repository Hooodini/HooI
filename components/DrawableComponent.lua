local HooI

return function(lib)
    HooI = lib
    local DrawableComponent = HooI.component.create("DrawableComponent")

    function DrawableComponent:initialize(...)
        HooI.initComponent(self, {
            {name = "drawable", varType = {"Image", "Animation"} }, 
            {name = "layer", varType = "number"},
            {name = "dx", varType = "number", default = 0},
            {name = "dy", varType = "number", default = 0},
            {name = "dw", varType = "number", default = 0},
            {name = "dh", varType = "number", default = 0},
        }, ...)

        self.sx = nil
        self.sy = nil
    end

    return DrawableComponent
end
