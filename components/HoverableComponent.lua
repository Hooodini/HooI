local HooI

return function(lib)
    HooI = lib
    local HoverableComponent = HooI.component.create("HoverableComponent")

    function HoverableComponent:initialize(...)
        HooI.initComponent(self, {
            {name = "selectedCallback", varType = "function"}, 
            {name = "deselectedCallback", varType = "function"},
            {name = "layer", varType = "number", default = 1},
            {name = "dx", varType = "number", default = 0},
            {name = "dy", varType = "number", default = 0},
            {name = "dw", varType = "number", default = 0},
            {name = "dh", varType = "number", default = 0},
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
end
