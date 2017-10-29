local HooI

return function(lib)
    HooI = lib
    local HoverUpdateSystem = HooI.class("HoverUpdateSystem", HooI.system)

    function HoverUpdateSystem:initialize(canvas)
    	self.class.super.initialize(self)
    	self.layers = {}
        self.canvas = canvas
    end

    function HoverUpdateSystem:onAddEntity(entity)
    	local hc = entity:get("HoverableComponent")

        if not self.layers[hc.layer] then
        	for i=#self.layers + 1, hc.layer do
        		self.layers[i] = {}
        	end
        end
        table.insert(self.layers[hc.layer], entity)
    end

    function HoverUpdateSystem:onRemoveEntity(entity)
    	for _, layer in pairs(self.layers) do
    		for k, e in pairs(layer) do
    			if e == entity then
    				table.remove(layer, k)
    			end
    		end
    	end
    end

    function HoverUpdateSystem:update(dt)
        local mx, my = love.mouse.getPosition()

        local entityHovered = false

        local wc, hc, x, y, w, h

        for i = #self.layers, 1, -1 do
        	for _, entity in pairs(self.layers[i]) do
        		wc = entity:get("WidgetComponent")
        		hc = entity:get("HoverableComponent")

        		x = wc.x + hc.x
        		y = wc.y + hc.y
                w = wc.w + hc.w
        		h = wc.h + hc.h

        		if mx > x and mx < x + w and my > y and my < y + h then
        			if not hc.hovered then
        				hc.hovered = true
                        entity.eventManager:fireEvent(HooI.events.HoverEvent(entity, true))
        			end
        		else
                    if self.canvas.mode == "mouse" then
                        if hc.hovered then
        				    hc.hovered = false
                            entity.eventManager:fireEvent(HooI.events.HoverEvent(entity, false))
                        end
        			end
        		end
        	end
        end
    end

    function HoverUpdateSystem:requires()
        return {"WidgetComponent", "HoverableComponent"}
    end

    return HoverUpdateSystem
end
