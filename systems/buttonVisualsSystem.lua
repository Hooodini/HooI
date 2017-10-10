local ButtonDrawSystem = HooI.class("ButtonDrawSystem", HooI.system)

function ButtonDrawSystem:initialize(canvas)
	self.class.super:initialize()
	
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
	dc = event.entity:get("DrawableComponent")
	bvc = event.entity:get("ButtonVisualsComponent")
	if event.isHovered then
		dc.drawable = bvc.hover
	else
		dc.drawable = bvc.normal
	end
end

function ButtonDrawSystem:clickEvent(event)
	local hc, dc, bvc
	for _, entity in pairs(self.targets) do
		hc = entity:get("HoverableComponent")
		dc = entity:get("DrawableComponent")
		bvc = entity:get("ButtonVisualsComponent")
		if hc.hovered then
			if bvc.button == event.button then
				if event.isPressed then
					dc.drawable = bvc.click
				else
					dc.drawable = bvc.hover
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
			bc.sx = w / bc.drawable:getWidth()
		end
		if not bc.sy then
			h = wc.h
			bc.sy = h / bc.drawable:getHeight()
		end

		love.graphics.draw(bc.drawable, wc.x, wc.y, 0, bc.sx, bc.sy)
    end
end

function ButtonDrawSystem:requires()
    return {"WidgetComponent", "ButtonComponent"}
end

return ButtonDrawSystem