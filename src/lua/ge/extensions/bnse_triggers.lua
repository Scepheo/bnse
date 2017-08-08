----------------------------------------------------------------------------------------------------
-- bnse_triggers.lua
-- Component that allows easy creation and usage of triggers base on distance between objects.
----------------------------------------------------------------------------------------------------

-- List of all currently active triggers
local triggers = {}


-- Local code
----------------------------------------------------------------------------------------------------

local bnse_trigger = {}
bnse_trigger.__index = bnse_trigger

function bnse_trigger:destroy()
	triggers[self.name] = nil
end


-- Global code
----------------------------------------------------------------------------------------------------

local currentId = 0

local function noop()
end

local function create(from, to, distance, events)
	local newTrigger = {
		fromObject = scenetree.findObject(from),
		toObject = scenetree.findObject(to),
		distanceSquared = distance * distance,
		enterTriggered = true,
		leaveTriggered = true,
		onEnter = events.onEnter or noop,
		onLeave = events.onLeave or noop,
		id = currentId
	}
	
	currentId = currentId + 1
	
	triggers[currentId] = newTrigger
		
	setmetatable(newTrigger, bnse_trigger)
	
	return newTrigger
end

local function update()
	for id, trigger in pairs(triggers) do
		local fromPos = vec3(trigger.fromObject:getPosition())
		local toPos = vec3(trigger.toObject:getPosition())
		local distanceSquared = fromPos:squaredDistance(toPos)
		
		if distanceSquared < trigger.distanceSquared then
			leaveTriggered = false
			
			if not enterTriggered then
				enterTriggered = true
				trigger.onEnter()
			end	
		else
			enterTriggered = false
				
			if not leaveTriggered then
				leaveTriggered = true
				trigger.onLeave()
			end
		end
	end
end


-- Interface
----------------------------------------------------------------------------------------------------

return {
	triggers = {
		create = create,
		update = update
	}
}
