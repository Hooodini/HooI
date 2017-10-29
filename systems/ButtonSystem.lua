local HooI

return function(lib)
	HooI = lib
	local ButtonSystem = HooI.class("ButtonSystem", HooI.system)

	function ButtonSystem:initialize(canvas)
		self.class.super.initialize(self)
		
		canvas.eventManager:addListener("SelectionEvent", self, self.selectionEvent)
	end

	function ButtonSystem:onAddEntity(entity)
		if not entity:get("HoverableComponent") then
			entity:add(HooI.hoverable())
		end
		if not entity:get("ClickableComponent") then
			entity:add(HooI.clickable())
		end
	end

	function ButtonSystem:selectionEvent(event)
		local entity, sc, bc
		entity = event.entity
		sc = entity:get("SelectableComponent")
		bc = entity:get("ButtonComponent")

		if event.selected then
			if event.pressed then
				bc.current = bc.clickDrawable
			else
				bc.current = bc.hoverDrawable
			end
		else
			bc.current = bc.normalDrawable
		end
	end

	function ButtonSystem:draw()
		local wc, bc, w, h
	    for k, entity in pairs(self.targets) do
	    	wc = entity:get("WidgetComponent")
	    	bc = entity:get("ButtonComponent")
	    	if not entity:get("SelectableComponent") then
	    		print("[!] ButtonSystem error. Entity without selectable component detected! Key inputs won't be able to select this button!")
	    	end

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

	function ButtonSystem:requires()
	    return {"WidgetComponent", "ButtonComponent"}
	end

	return ButtonSystem
end
