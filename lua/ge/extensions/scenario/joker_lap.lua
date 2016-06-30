----------------------------------------------------------------------------------------------------
-- joker_lap.lua
-- Scenario extension that adds joker laps. Mostly a copy of race.lua, hence:
--
-- This Source Code Form is subject to the terms of the bCDDL, v. 1.1.
-- If a copy of the bCDDL was not distributed with this
-- file, You can obtain one at http://beamng.com/bCDDL-1.1.txt
----------------------------------------------------------------------------------------------------

local M = {}

local scenario = nil

local finalTime = 0
local path = package.path

local jokerMarker = require("scenario/joker_marker")

local player

local jokerLapDone = false
local jokerLapEnabled = false

local jokerLapConfig = {}
local jokerWaypointBefore = ""
local jokerWaypointAfter = ""
local jokerSecondWaypoint = ""
local jokerWaypointSetNext = ""

local currentWaypointIndex
local nextWaypointIndex

-- Data for updating the normal race progress
local jokerStartIndex
local jokerEndIndex

-- Trigger
local triggerPosition
local triggerRadiusSquared

local function setTrigger(position, radius)
	triggerPosition = position
	triggerRadiusSquared = radius * radius
end

local function checkTrigger()
	if triggerPosition then
		local pos = vec3(player:getPosition())
		
		if pos:squaredDistance(triggerPosition) < triggerRadiusSquared then
			triggerPosition = nil
			triggerRadiusSquared = nil
			return true
		else
			return false
		end
	else
		return false
	end
end

local function onRaceResult()
	if not jokerLapDone then
		scenarios.finish({failed = "You didn't complete the joker lap!"})
	end
end

local function disableJokerLap()
	jokerLapEnabled = false
	setTrigger(nil, 0)
	
	currentWaypointIndex = -1
	nextWaypointIndex = -1
	
	jokerMarker.hide(true)
end

-- callback for the waypoint system
-- called when a vehicle drives through the targeted waypoint
local function onJokerWaypoint()

	-- Update display
	if currentWaypointIndex > 0 then
		guihooks.trigger('WayPoint', 'Joker Checkpoint ' .. tostring(currentWaypointIndex)..' / '..tostring(#jokerLapConfig))
	end
	
	-- Disable regular waypoints upon taking the joker lap
	if currentWaypointIndex == 1 then
		scenetree.raceMarker.hidden = true
		scenetree.raceMarkerBase.hidden = true
		scenetree.raceMarkerNext.hidden = true
		player:queueLuaCommand('scenario.reset()')
	end

	currentWaypointIndex = nextWaypointIndex
	nextWaypointIndex = nextWaypointIndex + 1

	if currentWaypointIndex > #jokerLapConfig then
		print('complete')
		 
		jokerLapDone = true
	
		-- Insert waypoint update
		local w = scenario.waypoints[scenario.focusSlot]
		
		while w.next < jokerEndIndex do
			race.onScenarioVehicleTrigger(scenario.focusSlot)
		end
	
		disableJokerLap()
		
		return
	end

	local waypoint = scenario.nodes[jokerLapConfig[currentWaypointIndex]]
  
	-- aim for the next waypoint
	setTrigger(waypoint.pos, waypoint.radius)
	
	-- Set joker marker
	jokerMarker.setPosition(vec3(waypoint.pos), waypoint.radius)
	
	local nextWaypoint
	
	if nextWaypointIndex <= #jokerLapConfig then
		nextWaypoint = scenario.nodes[jokerLapConfig[nextWaypointIndex]]
	else
		nextWaypoint = scenario.nodes[jokerWaypointAfter]
	end
	
	jokerMarker.setNextPosition(vec3(nextWaypoint.pos), nextWaypoint.radius)
end

local function enableJokerLap()
	jokerLapEnabled = true
	
	currentWaypointIndex = 0
	nextWaypointIndex = 1
	
	onJokerWaypoint()
end

local function onScenarioChange(sc)
  scenario = sc
  
  if not scenario then return end

  if scenario.state == 'pre-start' then
  
	player = scenetree.findObject('scenario_player0')
  
	jokerLapConfig = scenario.jokerLapConfig
	jokerWaypointBefore = scenario.jokerWaypointBefore
	jokerWaypointAfter = scenario.jokerWaypointAfter
	
	for i, wp in ipairs(scenario.lapConfig) do
		if wp == jokerWaypointBefore then
			jokerStartIndex = i
		end
		
		if wp == jokerWaypointAfter then
			jokerEndIndex = i
		end
	end
	
	jokerSecondIndex = jokerStartIndex + 1
	if jokerSecondIndex > #scenario.lapConfig then jokerSecondIndex = 1 end
	
	jokerSecondWaypoint = scenario.lapConfig[jokerSecondIndex]
	
	
	jokerSetNextIndex = jokerStartIndex - 1
	if jokerSetNextIndex < 1 then jokerSetNextIndex = #scenario.lapConfig end
	
	jokerWaypointSetNext = scenario.lapConfig[jokerSetNextIndex]

  elseif scenario.state == 'running' then

    jokerMarker.init()
	
	if jokerStartIndex == #scenario.lapConfig then
		enableJokerLap()
	end
	
  end
end

-- called before rendering a graphics frame
local function onPreRender(dt)

  if scenario == nil then return end

  if scenario.state == 'running' and be:getEnabled() and jokerLapEnabled then

    -- blend the marker
    jokerMarker.render()
	
	-- check the trigger
	if checkTrigger() then
		onJokerWaypoint()
	end
	
  end
  
end

local function onRaceWaypoint(data)
	
	if data.waypointName == jokerWaypointBefore and not jokerLapDone then
	
		-- See if we're on the last waypoint
		local playerId = scenario.focusSlot
		local waypoint = scenario.waypoints[playerId]
		
		if waypoint.next then
		    enableJokerLap()
		end
		
	elseif data.waypointName == jokerWaypointSetNext and not jokerLapDone then
		
		-- See if we're on the second-to-last
		local playerId = scenario.focusSlot
		local waypoint = scenario.waypoints[playerId]
		
		local next2 = waypoint.next + 1
		
		if next2 <= #scenario.lapConfig or waypoint.lap + 1 < scenario.lapCount then
		    local firstWaypoint = scenario.nodes[jokerLapConfig[1]]
			jokerMarker.setNextPosition(vec3(firstWaypoint.pos), firstWaypoint.radius)
		end
		
    elseif data.waypointName == jokerSecondWaypoint then
	
		disableJokerLap()
		
	end
end

-- public interface
M.onScenarioChange = onScenarioChange
M.onPreRender = onPreRender
M.onScenarioVehicleTrigger = onScenarioVehicleTrigger
M.onRaceWaypoint = onRaceWaypoint
M.onRaceResult = onRaceResult

return M
