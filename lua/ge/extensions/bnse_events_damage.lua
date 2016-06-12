----------------------------------------------------------------------------------------------------
-- Configuration
----------------------------------------------------------------------------------------------------

-- Minimum damage required to trigger an event
local damageThreshold = 10


----------------------------------------------------------------------------------------------------
-- Code
----------------------------------------------------------------------------------------------------

local damageList = {}

local function onVehicleSpawn(name)
	damageList[name] = { damage = 0, damaging = false }
end

local function onVehicleDespawn(name)
	damageList[name] = nil
end

local function onTick()
	for name, data in pairs(damageList) do
		local newData = map.objects[name]
	
		if newData then
			if newData.damage < data.damage then
				data.damage = newData.damage
				data.damaging = false
			elseif newData.damage - data.damage > damageThreshold then
				data.damage = newData.damage
					
				if not data.damaging then
					data.damaging = true
					extensions.hook('onVehicleDamage', name, data.damage)
				end
			else
				data.damaging = false
			end
		end
	end
end


----------------------------------------------------------------------------------------------------
-- Interface
----------------------------------------------------------------------------------------------------

return {
	onVehicleSpawn = onVehicleSpawn,
	onVehicleDespawn = onVehicleDespawn,
	onTick = onTick
}