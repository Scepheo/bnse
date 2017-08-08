----------------------------------------------------------------------------------------------------
-- bnse_events_damage.lua
-- This module exposes the 'onVehicleDamage' event (in GE Lua)
----------------------------------------------------------------------------------------------------


-- Config
----------------------------------------------------------------------------------------------------

-- Minimum time between two events
local timeThreshold = 1

-- Minimum damage taken to trigger an event
local damageThreshold = 10


-- Code
----------------------------------------------------------------------------------------------------

-- Time since last taken damage
local currentTime = 0

-- Amount of damage on last tick
local lastDamage = 0

-- Whether we can currently trigger the event
local canTrigger = true

local function sendEvent()
	local command = string.format('extensions.hook("onVehicleDamage", %d, %d)', obj:getID(), lastDamage)
	obj:queueGameEngineLua(command)
end

local function updateGFX(dt)
	local currentDamage = beamstate.damage
	local damageTaken = currentDamage - lastDamage
	lastDamage = currentDamage
	
	if damageTaken > damageThreshold then
		currentTime = 0
		
		if canTrigger then
			sendEvent()
			canTrigger = false
		end
	elseif not canTrigger then	
		currentTime = currentTime + dt
		
		if currentTime > timeThreshold then
			canTrigger = true
		end
	end
end


-- Interface
----------------------------------------------------------------------------------------------------

return {
	updateGFX = updateGFX
}
