local ButtonDrawSystem = HooI.class("ButtonDrawSystem", HooI.system)

function ButtonDrawSystem:initialize(canvas)
	self.class.super.initialize(self)
	
	canvas.eventManager:addListener("HoverEvent", self, self.hoverEvent)
	canvas.eventManager:addListener("ClickEvent", self, self.clickEvent)
end

function ButtonDrawSystem:onAddEntity(entity)
	if not entity:get("HoverableComponent") then
		entity:add(HooI.hoverable())
	end
	if not entity:get("ClickableComponent") then
		entity:add(HooI.clickable())
	end
end

function ButtonDrawSystem:hoverEvent(event)
	bc = event.entity:get("ButtonComponent")
	if event.isHovered then
		bc.current = bc.hoverDrawable
	else
		bc.current = bc.normalDrawable
	end
end

function ButtonDrawSystem:clickEvent(event)
	local hc, dc, bc
	for _, entity in pairs(self.targets) do
		hc = entity:get("HoverableComponent")
		bc = entity:get("ButtonComponent")
		if hc.hovered then
			if bc.button == event.button then
				if event.isPressed then
					bc.current = bc.clickDrawable
				else
					bc.current = bc.hoverDrawable
				end
			end
		end
	end
end

function ButtonDrawSystem:draw()
	local wc, bc, w, h
    for k, entity in pairs(self.targets) do
    	wc = entity:get("WidgetComponent")
    	bc = entity:get("ButtonComponent")

		if not bc.sx then
			w = wc.w
			bc.sx = w / bc.current:getWidth()
		end
		if not bc.sy then
			h = wc.h
			bc.sy = h / bc.current:getHeight()
		end

		love.graphics.draw(bc.current, wc.x, wc.y, 0, bc.sx, bc.sy)
    end
end

function ButtonDrawSystem:requires()
    return {"WidgetComponent", "ButtonComponent"}
end

return ButtonDrawSystem