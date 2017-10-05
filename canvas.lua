local Canvas = HooI.class("Canvas")

function Canvas:initialize(canvasName, active, systems)
	self.canvasName = canvasName or "GenericCanvas"
	self.engine = HooI.engine()
	self.eventManager = HooI.eventManager();

	-- ToDo Add Systems

	self.widgets = {}
	self.active = active or true

	if type(systems) == "table" then
		for _, v in pairs(systems) do
			if HooI.systems[v] then
				self:addSystem(HooI.systems[v])
			end
		end
	end
end

function Canvas:update(dt)
	self.engine:update(dt)
end

function Canvas:draw()
	self.engine:draw()
end

function Canvas:mousePressed(x, y, button)
	return self.eventManager:fireEvent(HooI.events.MousePressed(x, y, button))
end

function Canvas:mouseReleased(x, y, button)
	return self.eventManager:fireEvent(HooI.events.MouseReleased(x, y, button))
end

function Canvas:add(newWidget)
	-- ToDo check newWidget type
	self.engine:addEntity(newWidget)
end

function Canvas:remove(widget, removeChildren)
	-- ToDo check widget type
	self.engine:removeEntity(widget, removeChildren)
end

function Canvas:addSystem(newSystem)
	-- ToDo check newSystem type
	self.engine:addSystem(newSystem(self))
end

function Canvas:startSystem(system)
	-- ToDo check system type
	self.engine:startSystem(system)
end

function Canvas:stopSystem(system)
	-- ToDo check system type
	self.engine:stopSystem(system)
end

function Canvas:toggleSystem(system)
	-- ToDo check system type
	self.engine:toggleSystem(system)
end

-- self.active will be updated by activateCanvas / deactivateCanvas
function Canvas:activate()
	HooI:activateCanvas(self)
end

function Canvas:deactivate()
	HooI:deactivateCanvas(self)
end

return Canvas