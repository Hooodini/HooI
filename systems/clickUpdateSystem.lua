local ClickSystem = HooI.class("ClickSystem", HooI.system)

function ClickSystem:initialize(canvas)
	self.class.super:initialize()
	self.layers = {}

	canvas.eventManager:addListener("MousePressed", self, self.mouseEvent)
	canvas.eventManager:addListener("MouseReleased", self, self.mouseEvent)
end

function ClickSystem:onAddEntity(entity)
	local cc = entity:get("ClickableComponent")
    if not self.layers[cc.layer] then
    	for i=#self.layers + 1, cc.layer do
    		self.layers[i] = {}
    	end
    end
    table.insert(self.layers[hc.layer], entity)
end

function ClickSystem:onRemoveEntity(entity)
	for _, layer in pairs(self.layers) do
		for k, e in pairs(layer) do
			if e == entity then
				table.remove(layer, k)
			end
		end
	end
end

function ClickSystem:mouseEvent(event)
	local wc, cc, x, y, w, h
	for i = #self.layers, 1, -1 do
    	for _, entity in pairs(self.layers[i]) do
    		wc = entity:get("WidgetComponent")
    		cc = entity:get("ClickableComponent")
    		
    		x = wc.x
    		if cc.x then
    			x = x + cc.x
    		end
    		y = wc.y
    		if cc.y then
    			y = y + cc.y
    		end
    		w = wc.w
    		if cc.w then
    			w = w + cc.w
    		end
    		h = wc.h
    		if cc.h then
    			h = h + cc.h
    		end

    		if x < event.x and x + w > event.x and y < event.y and y + h > event.y then
    			if event.name == "MousePressed" then
    				entity:get("ClickableComponent").pressed = true
    				return true
    			elseif event.name == "MouseReleased" then
    				if cc.pressed then
    					cc.clickCallback()
    				end
    				return true
    			end
    		end
    	end
    end
end	

function ClickSystem:requires()
    return {"WidgetComponent", "ClickalbeComponent"}
end

function ClickSystem