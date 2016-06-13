----------------------------------------------------------------------------------------------------
-- resettable_scenarios.lua
-- This doesn't actually handle the resets, but prevents the scenario from automatically
-- restarting on a "reset" physics event if managedRestart is set in the scenario json.
-- This should be loaded on game start and used to replace the original scenarios module.
----------------------------------------------------------------------------------------------------

-- Load the original scenarios module
local scenarios = require('scenarios')

-- Remember the original handler, so we can still use it ourselves
local originalPhysicsEventHandler = scenarios.onPhysicsEngineEvent

-- Wrapper that prevents the original handler from being called if managedRestart is set
local function customPhysicsEventHandler(eventType)
	local scenario = scenarios.getScenario()
	
	if not scenario or not scenario.managedRestart then
		originalPhysicsEventHandler(eventType)
	end
end

-- Overwrite the module's handler with our wrapper
scenarios.onPhysicsEngineEvent = customPhysicsEventHandler

-- Expose a scenario restart function that other scripts can use
local function restart()
	originalPhysicsEventHandler('reset')
end

scenarios.restart = restart

-- Return the altered module
return scenarios