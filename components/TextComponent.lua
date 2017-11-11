local HooI

return function(lib)
    HooI = lib
    local TextComponent = HooI.component.create("TextComponent")

    function TextComponent:initialize(...)
        HooI.initComponent(self, {
            {name = "string", varType = {"string", "table"}, default = ""}, 
            {name = "font", varType = "Font"},
            {name = "dx", varType = "number", default = 0},
            {name = "dy", varType = "number", default = 0}
        }, ...)
    end

    return TextComponent
end
