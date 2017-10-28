local InteractableSystem = HooI.class("InteractableSystem", HooI.system)

function InteractableSystem:initialize(canvas)
	self.class.super.initialize(self)
	self.activeInteractable = nil
	self.canvas = canvas
	canvas.eventManager:addListener("HoverEvent", self, self.hoverEvent)
end

function InteractableSystem:onAddEntity(entity)
	ttc = entity:get("TooltipComponent")
	if not ttc.init then
		ttc.init = true
		entity:getEngine():addEntity(ttc.widget)
		ttc.widget:deactivate()
	end
end

function InteractableSystem:hoverEvent(event)
	local ic = event.entity:get("InteractableComponent")

	if self.canvas.exclusiveMode and self.canvas.mode == "input" then
		return
	end

	if ic then
		ic.active = true
		if self.activeInteractable then
			self.activeInteractable:get("InteractableComponent").active = false
			self.activeInteractable = event.entity
			self.canvas.mode = "mouse"
			return true
		end
	end
end

function InteractableSystem:requires()
    return {"WidgetComponent", "InteractableComponent"}
end

return InteractableSystem