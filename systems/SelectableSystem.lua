local HooI

return function(lib)
	HooI = lib
	local SelectableSystem = HooI.class("SelectableSystem", HooI.system)

	function SelectableSystem:initialize(canvas)
		self.class.super.initialize(self)
		
		canvas.eventManager:addListener("HoverEvent", self, self.hoverEvent)
		canvas.eventManager:addListener("ClickEvent", self, self.clickEvent)
		canvas.eventManager:addListener("KeyInputEvent", self, self.keyInputEvent)
		canvas.eventManager:addListener("SelectionEvent", self, self.selectionEvent)
		self.selectedEntity = nil
	end

	function SelectableSystem:onEntityAdded(entity)
		if not self.selectedEntity then
			self.selectedEntity = entity
		end
	end

	function SelectableSystem:selectionEvent(event)
		if event.released then
			local cc = event.entity:get("ClickableComponent")
			if cc then
				cc.clickCallback(event.entity)
			end
		end
	end

	-- ToDo Add input listener. Directional and execution.
	function SelectableSystem:keyInputEvent(event)
		if self.selectedEntity then
			if self.selectedEntity:get("SelectableComponent")[event.inputType] then
				local entity = self.selectedEntity:get("SelectableComponent")[event.inputType]

				self.selectedEntity.selected = false
				self.selectedEntity.pressed = false
				entity.selected = true
				entity.pressed = false
				entity.eventManager:fireEvent(HooI.events.SelectionEvent(entity, true, false, false))
				self.selectedEntity.eventManager:fireEvent(HooI.events.SelectionEvent(self.selectedEntity, false, false, false))
				self.selectedEntity = entity
			elseif event.inputType == "press" then
				self.selectedEntity.pressed = true
				self.selectedEntity.eventManager:fireEvent(HooI.events.SelectionEvent(self.selectedEntity, true, true, false))
			elseif event.inputType == "execute" then
				if self.selectedEntity.pressed then
					self.selectedEntity.pressed = false
					self.selectedEntity.eventManager:fireEvent(HooI.events.SelectionEvent(self.selectedEntity, true, false, true))
				end
			end
		end
	end

	function SelectableSystem:hoverEvent(event)
		local entity, sc
		entity = event.entity
		sc = entity:get("SelectableComponent")

		if event.isHovered then
			if self.selectedEntity then
				self.selectedEntity:get("SelectableComponent").selected = false
			end
			self.selectedEntity = entity
			sc.selected = true

			entity.eventManager:fireEvent(HooI.events.SelectionEvent(entity, true, false, false))
		else
			sc.selected = false
			entity.eventManager:fireEvent(HooI.events.SelectionEvent(entity, false, false, false))
		end
	end

	function SelectableSystem:clickEvent(event)
		local entity, sc
		entity = event.entity
		sc = entity:get("SelectableComponent")

		if sc.selected then
			if event.isPressed then
				sc.pressed = true
				entity.eventManager:fireEvent(HooI.events.SelectionEvent(entity, true, true, false))
			else
				sc.pressed = false
				entity.eventManager:fireEvent(HooI.events.SelectionEvent(entity, true, false, true))
			end
		end
	end

	function SelectableSystem:requires()
	    return {"WidgetComponent", "SelectableComponent"}
	end

	return SelectableSystem
end
