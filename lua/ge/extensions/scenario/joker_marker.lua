----------------------------------------------------------------------------------------------------
-- joker_maker.lua
-- Scenario script for a green checkpoint marker, used by the joker_race extension. Large parts are
-- copied from race_marker.lua, so:
--
-- This Source Code Form is subject to the terms of the bCDDL, v. 1.1.
-- If a copy of the bCDDL was not distributed with this
-- file, You can obtain one at http://beamng.com/bCDDL-1.1.txt
----------------------------------------------------------------------------------------------------

local M = {}

--- jokerMarker position
local markerPosition = nil

--- jokerMarkerNext position
local markerNextPosition = nil

--[[doxygen
It hides all raceMarkers.
@param b    a boolean type
void hide(bool b);
--]]
local function hide(b)
  scenetree.jokerMarker.hidden = b
  scenetree.jokerMarkerBase.hidden = b
  scenetree.jokerMarkerNext.hidden = b
end

--[[doxygen
It initializes jokerMarker,jokerMarkerBase and jokerMarkerNext.
Meanwhile, it also clear the states of raceMarkers.

void init();
--]]
local function init()
  local ts = [[
if(isObject(jokerMarker)){
	jokerMarker.delete();
}
new TSStatic(jokerMarker){
	shapeName = "art/shapes/interface/checkpoint_marker.dae";
	useInstanceRenderData = "1";
	instanceColor = "0.1 1 0.1 1";
};
ScenarioObjectsGroup.add(jokerMarker);
if(isObject(jokerMarkerNext)){
	jokerMarkerNext.delete();
}
new TSStatic(jokerMarkerNext){
	shapeName = "art/shapes/interface/checkpoint_marker.dae";
	useInstanceRenderData = "1";
	instanceColor = "0.3 0.3 0.3 0.5";
};
ScenarioObjectsGroup.add(jokerMarkerNext);
if(isObject(jokerMarkerBase)){
  jokerMarkerBase.delete();
}
new TSStatic(jokerMarkerBase) {
	shapeName = "art/shapes/interface/checkpoint_marker_base.dae";
	useInstanceRenderData = "1";
	instanceColor = "1 1 1 0.8";
};
ScenarioObjectsGroup.add(jokerMarkerBase);
]]
  --log('D', 'race.onScenarioChange', 'executing TS: ' .. ts)
  TorqueScript.eval(ts)
  hide(true)
  markerPosition = nil
  markerNextPosition = nil
end

--[[doxygen
It is to render marker color during the scenario.
void render();
--]]
local function render()
   -- blend the marker
  local camPos = vec3(getCameraPosition())
  
  if scenetree.jokerMarker and markerPosition then
    local camdistSqt = markerPosition:squaredDistance(camPos)
    local markerAlpha = camdistSqt / 2000
    if markerAlpha > 1 then markerAlpha = 1 end
    scenetree.jokerMarker.instanceColor = ColorF( 0.1, 1, 0.1, markerAlpha):asLinear4F()
    scenetree.jokerMarkerBase.instanceColor = ColorF( 1, 1, 1, markerAlpha * 0.8):asLinear4F()
  end

  if scenetree.jokerMarkerNext and markerNextPosition then
    local camdistSqt = markerNextPosition:squaredDistance(camPos)
    local markerAlpha = camdistSqt / 2000
    if markerAlpha > 1 then markerAlpha = 1 end
    scenetree.jokerMarkerNext.instanceColor = ColorF( 0.3, 0.3, 0.3, markerAlpha * 0.5):asLinear4F()
  end

end


--[[doxygen
It sets new positions to jokerMarker and jokerMarkerBase in order the change their location.
@param pos    a table type for new position
@param nextRadius    a double type for new radius of marker
void setPosition(table pos, double nextRadius);
--]]
local function setPosition(pos, nextRadius)
  markerPosition = vec3(pos)
  scenetree.jokerMarker.hidden = false
  scenetree.jokerMarker:setPosition(markerPosition:toPoint3F())
  scenetree.jokerMarker:setScale(Point3F(nextRadius, nextRadius, 50))
  scenetree.jokerMarkerBase.hidden = false
  scenetree.jokerMarkerBase:setPosition(markerPosition:toPoint3F())
  scenetree.jokerMarkerBase:setScale(Point3F(nextRadius*2, nextRadius*2, nextRadius*2))
end

--[[doxygen
It sets new positions to jokerMarkerNext in order the change their location.
@param posNext    a table type for new position
@param next2Radius    a double type for new radius of marker
void setNextPosition(table posNext, double next2Radius);
--]]
local function setNextPosition(posNext, next2Radius)
  markerNextPosition = vec3(posNext)
  scenetree.jokerMarkerNext.hidden = false
  scenetree.jokerMarkerNext:setPosition(markerNextPosition:toPoint3F())
  scenetree.jokerMarkerNext:setScale(Point3F(next2Radius, next2Radius, 50))
end

--[[doxygen
It initializes jokerMarker,jokerMarkerBase and jokerMarkerNext.
Meanwhile, it also clear the states of raceMarkers.
void init();
--]]
M.init = init

--[[doxygen
It is to render marker color during the scenario.
void render();
--]]
M.render = render

--[[doxygen
It hides all raceMarkers.
@param b    a boolean type
void hide(bool b);
--]]
M.hide = hide

--[[doxygen
It sets new positions to jokerMarker and jokerMarkerBase in order the change their location.
@param pos    a table type for new position
@param nextRadius    a double type for new radius of marker
void setPosition(table pos, double nextRadius);
--]]
M.setPosition = setPosition

--[[doxygen
It sets new positions to jokerMarkerNext in order the change their location.
@param posNext    a table type for new position
@param next2Radius    a double type for new radius of marker
void setNextPosition(table posNext, double next2Radius);
--]]
M.setNextPosition = setNextPosition

return M
