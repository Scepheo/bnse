----------------------------------------------------------------------------------------------------
-- Code
----------------------------------------------------------------------------------------------------

local function enableTrackingFor(name)
	local vehicle = scenetree.findObject(name)
	vehicle:queueLuaCommand('mapmgr.enableTracking("'..name..'")')
end

local function enableTracking()
	local vehicles = scenetree.findClassObjects('BeamNGVehicle')
	
	for _, name in pairs(vehicles) do
		enableTrackingFor(name)
	end
end

local function onPhysicsEngineEvent(eventType)
	if eventType == 'spawn' or eventType == 'reset' then
		enableTracking()
	end
end


----------------------------------------------------------------------------------------------------
-- Interface
----------------------------------------------------------------------------------------------------

return {
	onPhysicsEngineEvent = onPhysicsEngineEvent
}