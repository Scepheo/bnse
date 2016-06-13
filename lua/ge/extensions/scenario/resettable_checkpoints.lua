----------------------------------------------------------------------------------------------------
-- resettable_checkpoints.lua
-- Scenario extension that allows the player to respawn at the last reached checkpoint.
----------------------------------------------------------------------------------------------------

-- Track running state
local running = false

-- Track scenario started state
local scenarioStarted = false


-- Scenario & player reset
----------------------------------------------------------------------------------------------------

-- Reset the player to the last checkpoint
local function resetPlayer()
	log('I', 'resetPlayer', 'setting player to reset position')
	TorqueScript.eval('scenario_player0.position = $resetPosition;')
	TorqueScript.eval('scenario_player0.rotation = $resetRotation;')
end

-- Restart the scenario
local function restartScenario()
	-- Put the player back at the starting position
	log('I', 'restartScenario', 'setting player to start position')
	TorqueScript.eval('scenario_player0.position = $startPosition;')
	TorqueScript.eval('scenario_player0.rotation = $startRotation;')
	
	-- Actually restart the scenario
	resettable_scenarios.restart()
	
	running = false
end


-- Events
----------------------------------------------------------------------------------------------------

local function onPhysicsEngineEvent(type, a1)
	if not scenarioStarted then
		return
	end

	if type == 'despawn' then
		restartScenario()
	elseif type == 'reset' then
		if running then
			resetPlayer()
		else
			restartScenario()
		end
	end
end

local function onRaceWaypoint(data)
	-- Set the reset location to the hit waypoint
	if data.waypointName and data.waypointName ~= '' then
		log('I', 'onRaceWaypoint', 'resetting player')
		TorqueScript.eval('$resetPosition = '..data.waypointName..'.position;')
		TorqueScript.eval('$resetRotation = '..data.waypointName..'.rotation;')
	end
end

local function onRaceStart()
	running = true
	
	-- Set the reset location to the player location
	log('I', 'onRaceStart', 'storing reset position')
	TorqueScript.eval('$resetPosition = scenario_player0.position;')
	TorqueScript.eval('$resetRotation = scenario_player0.rotation;')
	
	-- Remember the starting location, for actual scenario restarts
	log('I', 'onRaceStart', 'storing start position')
	TorqueScript.eval('$startPosition = scenario_player0.position;')
	TorqueScript.eval('$startRotation = scenario_player0.rotation;')
end

local function onScenarioChange(scenario)
	log('I', 'onScenarioChange', 'scenario.state: ' .. scenario.state)
	
	if scenario.state == 'pre-start' then
		scenarioStarted = true
	end
end

local function onRaceResult()
	running = false
end


-- Public interface
----------------------------------------------------------------------------------------------------

return {
	onPhysicsEngineEvent = onPhysicsEngineEvent,
	onRaceWaypoint = onRaceWaypoint,
	onRaceStart = onRaceStart,
	onRaceResult = onRaceResult,
	onScenarioChange = onScenarioChange
}