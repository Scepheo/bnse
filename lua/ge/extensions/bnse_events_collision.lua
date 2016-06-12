----------------------------------------------------------------------------------------------------
-- Configuration
----------------------------------------------------------------------------------------------------

-- Max collision distance (squared)
local distanceThresholdSquared = 100


----------------------------------------------------------------------------------------------------
-- Code
----------------------------------------------------------------------------------------------------

local tickDamages = {}

local function onVehicleDamage(id, damage)
	table.insert(tickDamages, id)
end

local function onTick()
	for i = 1, #tickDamages - 1 do
		local leftId = tickDamages[i]
		local leftVehicle = scenetree.findObject(leftId)
		local leftPos = vec3(leftVehicle:getPosition())
		
		for j = i + 1, #tickDamages do
			local rightId = tickDamages[j]
			local rightVehicle = scenetree.findObject(leftId)
			local rightPos = vec3(leftVehicle:getPosition())
			
			if leftPos:squaredDistance(rightPos) <= distanceThresholdSquared then
				extensions.hook('onVehicleCollision', leftId, rightId)
			end
		end
	end
	
	tickDamages = {}
end


----------------------------------------------------------------------------------------------------
-- Interface
----------------------------------------------------------------------------------------------------

return {
	onVehicleDamage = onVehicleDamage,
	onTick = onTick
}