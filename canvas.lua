local Canvas = HooI.class("Canvas")

function Canvas:initialize(canvasName, active, systems)
	self.canvasName = canvasName or "GenericCanvas"
	self.engine = HooI.engine()

	-- ToDo Add Systems

	self.widgets = {}
	self.active = active or true
end

function Canvas:addSystem(newSystem)
	-- ToDo check newSystem type
	self.engine:addSystem(newSystem)
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

function Canvas:add(newWidget)
	-- ToDo check newWidget type
	self.engine:addEntity(newWidget)
end

function Canvas:remove(widget, removeChildren)
	-- ToDo check widget type
	self.engine:removeEntity(widget, removeChildren)
end

function Canvas:update(dt)
	self.engine:update(dt)
end

function Canvas:activate()
	self.active = true
end

function Canvas:deactivate()
	self.active = false
end

function Canvas:draw()
	self.engine:draw()
end

return Canvas