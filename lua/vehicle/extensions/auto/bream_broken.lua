local currentTime = 0
local lastDamage = 0

local timeLimit = 1
local damageThreshold = 50

local sentDamage = false

local function sendEvent()
	obj:queueGameEngineLua('extensions.hook("onVehicleDamage", '..tostring(obj:getID())..', '..tostring(lastDamage)..')')
end

local function updateGFX(dt)
	local currentDamage = beamstate.damage
	local damageDiff = currentDamage - lastDamage
	lastDamage = currentDamage
	
	if damageDiff > damageThreshold then
		currentTime = 0
		
		if not sentDamage then
			sendEvent()
			sentDamage = true
		end
	elseif sentDamage then	
		currentTime = currentTime + dt
		
		if currentTime > timeLimit then
			sentDamage = false
		end
	end
end

return {
	updateGFX = updateGFX
}