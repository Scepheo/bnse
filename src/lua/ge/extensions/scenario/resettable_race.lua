----------------------------------------------------------------------------------------------------
-- resettable_race.lua
-- Scenario extension for races that allow the player to respawn at the last reached checkpoint.
-- This is mostly a copy from the official race.lua: all changes are marked with "EDIT START" and
-- "EDIT END".
----------------------------------------------------------------------------------------------------

-- This Source Code Form is subject to the terms of the bCDDL, v. 1.1.
-- If a copy of the bCDDL was not distributed with this
-- file, You can obtain one at http://beamng.com/bCDDL-1.1.txt

local M = {}

local scenario = nil

local finalTime = 0
local path = package.path

local raceMarker = require("scenario/race_marker")

-- EDIT START
-- Track the last waypoint trigger command, so we can re-issue it upon player reset
local vehicleTriggerCommand
-- EDIT END

-- use with care:
local raceTickTimer = 0
local raceTickTime = 0.25

local endRaceCountdown = 0;

-- freezing of the vehicles before the countdown is done
local function freezeAll(state)
  for k, vid in pairs(scenario.vehiclesByName) do
    local bo = be:getObjectByID(vid)
    if bo then
      print('freeze vehicle name: '..k..' '..tostring(bo))
      bo:queueLuaCommand('scenario.freeze('..tostring(state) ..')')
    end
  end
end

local function onRaceEnd()
  log( 'I', 'scenario.race', 'onRaceEnd' )
  endRaceCountdown = 0

  if scenario.state ~= 'post' then
      dump(finalTime)
    extensions.hook('onRaceResult', { finalTime = finalTime } )
  end

  if scenario.state == 'post' then
    return -- race finished on some extension
  end

  local minutes = math.floor(finalTime / 60);
  local seconds = finalTime - (minutes * 60);
  local timeStr = ''
  if minutes > 0 then
    timeStr = string.format("%02.0f:%05.2f", minutes, seconds)
  else
    timeStr = string.format("%0.2f", seconds) .. 's'
  end
  local result = {msg = 'Well done, your time: '..timeStr}

  --local timer = 0
  --if raceFailed then
  --  guihooks.trigger('ScenarioFlashMessage', {{'You failed!', 2}} )
  --  timer = 2.3
  --else
  --  guihooks.trigger('ScenarioFlashMessage', { {'well done!', 1},{'your time: ' .. timeStr, 5} } )
  --  timer = 3.5
    --print('final time: ' .. timeStr)
  --end
  scenarios.finish(result)
end

-- returns the next waypoint
local function getNextWaypoint(w, diff)
  local testWp = w.cur + diff
  if testWp > #scenario.lapConfig then
    if w.lap + 1 < scenario.lapCount then
      -- new lap
      return 1, 1
    else
      -- all done
      return nil, nil
    end
  end
  -- no new lap, just new waypoint
  return testWp, 0
end

-- callback for the waypoint system
-- called when a vehicle drives through the targeted waypoint
local function onScenarioVehicleTrigger(id)
  -- decide upon progress here and update the UI
  --print('onScenarioVehicleTrigger('..tostring(id)..')')

  if scenario.waypoints[id] == nil then
    scenario.waypoints[id] = { cur = -1, next = 0, lap = 0 }
  --  extensions.hook( 'onScenarioChange', scenario )
  end
  local w = scenario.waypoints[id]

  local vid = scenario.vehiclesByID[id]
  local bo = be:getObjectByID(vid)
  if not bo then return end


  --print("waypoint: cur:" .. id .. " = " .. w.cur .. ", next: " .. w.next)

  w.cur = w.next
  local lapDiff = -1
  w.next, lapDiff = getNextWaypoint(w, 1)

  log( 'D', 'scenarios.race', 'onTrigger wp '..tostring(w.cur) )

  extensions.hook( 'onRaceWaypoint', { cur = w.cur, vehicleName = bo:getField('name', ''), waypointName = scenario.lapConfig[w.cur] or "", time = scenario.timer} )

  if w.next == nil then
    -- all done
    scenario.state = 'finished'
    endRaceCountdown = 3;
    finalTime = scenario.timer
    raceMarker.hide(true)
    return
  end

  w.next2, _ = getNextWaypoint(w, 2)

  if lapDiff > 0 then
    -- changed laps?
    w.lap = w.lap + lapDiff
    --log( 'D', 'scenarios.race', 'onTriggerLap: '..tostring(w.lap) .. ' time: ' .. string.format("%.3f", scenario.timer) .. 's' )
    extensions.hook('onRaceLap', { lap = w.lap, time = scenario.timer } )
  end

  if not scenario.lapConfig[w.next] then
    log('E', 'race', 'next waypoint invalid: ' .. tostring(w.next))
    raceMarker.hide(true)
    return
  end
  if not scenario.nodes[scenario.lapConfig[w.next]] then
    log('E', 'race', 'waypoint not found: ' .. tostring(scenario.lapConfig[w.next]))
    raceMarker.hide(true)
    return
  end

  local nwp = scenario.nodes[scenario.lapConfig[w.next]]

  -- aim for the next waypoint
  -- EDIT START
  vehicleTriggerCommand = 'scenario.setTrigger("resettable_race.onScenarioVehicleTrigger", ' .. serialize(nwp.pos) .. ',' .. nwp.radius .. ');'
  bo:queueLuaCommand(vehicleTriggerCommand)
  -- EDIT END
  -- update the 3d markers
  -- now the next marker
  w.nextWp = scenario.nodes[scenario.lapConfig[w.next]]
  raceMarker.setPosition(vec3(w.nextWp.pos), w.nextWp.radius)

  -- now the 'next - 2' marker
  w.next2Wp = nil
  raceMarker.clearNextStat()
  if w.next2 then
    w.next2Wp = scenario.nodes[scenario.lapConfig[w.next2]]
    raceMarker.setNextPosition(vec3(w.next2Wp.pos),  w.next2Wp.radius)
  end
end

local function onScenarioChange(sc)
  log( 'D', 'scenarios.race', 'onScenarioChange: ' .. tostring(sc.state) )
  scenario = sc
  if not scenario then return end

  -- init the timer object
  if not scenario.timer then scenario.timer = 0 end

  if scenario.state == 'pre-start' then
    -- scenario is still in introduction phase
    guihooks.trigger('ScenarioResetTimer')
    scenario.raceState = ''
    freezeAll(1)

  elseif scenario.state == 'running' and scenario.raceState == '' then
    -- the scenario just entered running state
    scenario.waypoints = {}
    scenario.raceState = 'countdown'

    raceMarker.init()

    -- start the countdown
    scenario.timer = 0
    scenario.waypoints = {}

    extensions.hook("onRaceInit")
    -- tell the UI to actually count down
    guihooks.trigger('ScenarioFlashMessageReset')
    guihooks.trigger('ScenarioFlashMessage', {{3,1, true},{2,1, true},{1,1, true},{"go!", 1, 'extensions.hook("onScenarioRaceCountingDone")', true}})

    -- reset everything - EXCEPT the player vehicle
    -- otherwise, the setTrigger on the first waypoint is lost in the reset
    for _, vid in pairs(scenario.vehiclesByID) do
      if vid ~= scenario.focusSlot then
        local bo = be:getObjectByID(vid)
        if bo then
          bo:queueLuaCommand('obj:requestReset(RESET_PHYSICS)')
        end
      end
    end

    -- set the player target waypoint only
    if scenario.focusSlot then
      onScenarioVehicleTrigger(scenario.focusSlot)
    end

    freezeAll(1)

  elseif scenario.state == 'post' then
    -- scenario just finished
    scenario.raceState = 'done'
    raceMarker.hide(true)
  end
end


local scenarioPaused = false;

-- called before rendering a graphics frame
local function onPreRender(dt)
  if scenario == nil  then return end

  if scenario.state == 'running' and be:getEnabled() then
    -- scenario time
    if scenario.raceState == 'racing' and not scenarioPaused then
      scenario.timer = scenario.timer + dt
      guihooks.trigger('raceTime', scenario.timer)
    end
    -- blend the marker
    raceMarker.render()

    -- the race tick implementation
    raceTickTimer = raceTickTimer + dt

    if raceTickTimer > raceTickTime then
      raceTickTimer = raceTickTimer - raceTickTime
      extensions.hook('onRaceTick', raceTickTime, scenario.timer)
    end
  end

  if scenario.state == 'finished' then
    endRaceCountdown = endRaceCountdown - dt
    if endRaceCountdown < 0 then
      onRaceEnd()
    end
  end

end


-- callback for the UI: called when it finishes counting down
local function onScenarioRaceCountingDone()
  --log( 'D', 'scenarios.race', 'onScenarioCountingDone' )
  scenario.raceState = 'racing'

  -- unlock all vehicles
  freezeAll(0)

  -- reset the timers
  scenario.timer = 0
  raceTickTimer = 0

  -- let everyone know that we finally started
  extensions.hook('onRaceStart')
  guihooks.trigger('RaceStart')
end


local function pauseScenario()
  -- freezeAll(1)
  TorqueScript.call('beamNGsetPhysicsEnabled', false) --not final just for the proof of concept
  scenarioPaused = true;
end

local function continueScenario()
  -- freezeAll(0)
  TorqueScript.call('beamNGsetPhysicsEnabled', true) --not final just for the proof of concept
  scenarioPaused = false;
end

-- EDIT START
local function onPhysicsEngineEvent(type)
	if type == 'reset' and vehicleTriggerCommand then
		scenetree.scenario_player0:queueLuaCommand(vehicleTriggerCommand)
	end
end
-- EDIT END

extensions.loadModule('scenario/raceUI')
extensions.loadModule('scenario/raceGoals')
--extensions.loadModule('scenario/raceDebug')

-- public interface
M.onScenarioChange = onScenarioChange
M.onPreRender = onPreRender
M.onScenarioVehicleTrigger = onScenarioVehicleTrigger
M.onScenarioRaceCountingDone = onScenarioRaceCountingDone
M.onPauseScenario = pauseScenario
M.onContinueScenario = continueScenario


-- EDIT START
M.onPhysicsEngineEvent = onPhysicsEngineEvent
-- EDIT END

return M
