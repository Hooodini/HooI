package.path = package.path .. ";.\\?\\init.lua;..\\?.lua;..\\..\\?.lua"

HooECS = require("HooECS")

HooECS.initialize({globals=true, debug=true})

local Listener, TestEvent
local listener, eventManager, testEvent

-- Test Listener
Listener = HooECS.class('Listener')
Listener.number = 0
function Listener:test(event)
    self.number = event.number
end

function Listener:valueReturnTest(event)
    return event.number
end

Listener2 = HooECS.class('Listener2')

function Listener2:valueReturnTest(event)
    return event.number
end

-- Test Event
TestEvent = HooECS.class('TestEvent')
TestEvent.number = 12

eventManager = EventManager()
listener = Listener()
listener2 = Listener2()
testEvent = TestEvent()

eventManager:addListener('TestEvent', listener, listener.valueReturnTest)
eventManager:addListener('TestEvent', listener2, listener2.valueReturnTest)

--[[
eventManager:addListener('TestEvent', listener, listener.valueReturnTest)
assert.are.equal(eventManager:fireEvent(testEvent), 12)
eventManager:addListener('TestEvent', listener2, listener2.valueReturnTest)
assert.are.equal(eventManager:fireEvent(testEvent), {12, 12})
]]