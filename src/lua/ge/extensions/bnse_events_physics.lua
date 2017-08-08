----------------------------------------------------------------------------------------------------
-- bnse_events_physics.lua
-- This module exposes the following physics-related events: onVehicleSpawn, onVehicleReset and
-- onVehicleDespawn.
----------------------------------------------------------------------------------------------------


-- Code
----------------------------------------------------------------------------------------------------

-- List of all currently loaded vehicles
local vehicleList = {}

local function onVehicleResetted(id)
	if vehicleList[id] then
		extensions.hook('onVehicleReset', id)
	else
		extensions.hook('onVehicleSpawn', id)
		vehicleList[id] = true
	end
end

local function onDespawn()
	local newVehicles = scenetree.findClassObjects('BeamNGVehicle')
	
	local newVehicleList = {}
	
	for _, name in pairs(newVehicles) do
		local vehicle = scenetree.findObject(name)
		local id = vehicle.obj:getID()
		newVehicleList[id] = true
	end
	
	for id, _ in pairs(vehicleList) do
		if not newVehicleList[id] then
			extensions.hook('onVehicleDespawn', id)
			break
		end
	end
	
	vehicleList = newVehicleList
end

function onPhysicsEngineEvent()
	if eventType == 'despawn' then
		onDespawn()
	end
end


-- Interface
----------------------------------------------------------------------------------------------------

return {
	onPhysicsEngineEvent = onPhysicsEngineEvent,
	onVehicleResetted = onVehicleResetted
}
