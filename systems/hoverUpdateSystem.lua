local HoverUpdateSystem = HooI.class("HoverUpdateSystem", HooI.system)

function HoverUpdateSystem:initialize(canvas)
	self.class.super.initialize(self)
	self.layers = {}
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

    		x = wc.x
    		if hc.x then
    			x = x + hc.x
    		end
    		y = wc.y
    		if hc.y then
    			y = y + hc.y
    		end
    		w = wc.w
    		if hc.w then
    			w = w + hc.w
    		end
    		h = wc.h
    		if hc.h then
    			h = h + hc.h
    		end

			if mx > x and mx < x + w and my > y and my < y + h then
				if not hc.hovered then
					hc.enterCallback()
					hc.hovered = true
                    entity.eventManager:fireEvent(HooI.events.HoverEvent(entity, true))
				end
			else
				if hc.hovered then
					hc.hovered = false
					hc.leaveCallback()
                    entity.eventManager:fireEvent(HooI.events.HoverEvent(entity, false))
				end
			end
    	end
    end
end

function HoverUpdateSystem:requires()
    return {"WidgetComponent", "HoverableComponent"}
end

return HoverUpdateSystem
