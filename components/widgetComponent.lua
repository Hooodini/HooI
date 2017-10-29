local HooI

return function(lib)
    HooI = lib
    local WidgetComponent = HooI.component.create("WidgetComponent")

    function WidgetComponent:initialize(x, y, w, h)
        self.x = x or 0
        self.y = y or 0
        self.w = w or 50
        self.h = h or 50
    end

    return WidgetComponent
end
