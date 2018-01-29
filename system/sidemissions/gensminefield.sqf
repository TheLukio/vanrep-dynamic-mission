if (!isServer) exitWith {};

  // set false the side1 so side finder will not execute this mission again
  side5 = false;

// private variables for this script
private ["_markerSeaMineArray", "_centerPos","_mrk_sad","_minewarning", "_minesArray","_MissionStatus","_smineMission"]; // uncomment _trg if trigger used

_markerSeaMineArray = ["smine","smine_1","smine_2","smine_3","smine_4","smine_5","smine_6","smine_7","smine_8","smine_9","smine_10","smine_11"];
_minesArray = [];

// define centerpos from marker arrays
_centerPos = getMarkerPos (_markerSeaMineArray call BIS_fnc_selectRandom);

// Areamarker
nul = [75,75,"ColorRed",_centerPos,"ELLIPSE"] spawn SM_fn_createMarker;

 // create tasks
 _taskString0 = format ["Clear Underwater Mines<br/><br/>- Civilians have located and marked some drifting mines<br/><br/>- Use a minesweeper to detect mines<br/><br/>- Use a toolkit to disable all mines in the area."];
 _taskDesc0 = "Clear Minefield (Sea)";

[
 ["LMineClear0"],
 independent,
 [_taskString0, _taskDesc0,""],
 _centerPos,
 "AUTOASSIGNED",
 1,
 true,
 true,
 "Interact"
] call BIS_fnc_setTask;


// _testmineSpawn = createMine ["IEDLandSmall_F", _centerPos, [], 0];


// define variables for main loop
_smineMission = true;
_MissionStatus = 0;

// main loop
while { _smineMission} do {
    // spawn mines
		if ( _MissionStatus == 0 ) then {
			// foreach loop
      _mineWarning = "Land_BuoyBig_F" createVehicle _centerPos;

      _i = 0;
      _depth = 5;
      for [{_i=0}, {_i<5}, {_i=_i+1}] do
      {
        _minePos = [(_centerPos select 0) + ((random 10) - 30), (_centerPos select 1) + ((random 5) - 10),	-1 * (random _depth)];
        _mineSpawn = createMine ["Underwatermine", _minePos, [], 0];
        _minesArray pushBack _mineSpawn;
      };
      _MissionStatus = 1;
		};

			// check if evac is not active and all enemies in vicinity dead, then create marker & send wounded soldiers to evac point
      if ( _MissionStatus == 1 ) then {
        if ( { mineActive _x }count _minesArray == 0 ) exitWith {
    			//Set variable
          _MissionStatus = 2;
    		};
        sleep 0.5;
			};

			 if ( _MissionStatus == 2)  then {
          ['LMineClear0','Succeeded'] call BIS_fnc_taskSetState;
          // Mission cleanup
          deleteVehicle _mineWarning;
          sleep 1;
          {deleteVehicle _x} forEach  _minesArray;
          nul = [] spawn SM_fn_delMarker;
          sleep 5;
          ["LMineClear0",true] call BIS_fnc_deleteTask;
          sleep 1;
          if (isserver) then { null=[]execVM "sidefinder.sqf"; };
          sleep 1;
          _smineMission = false;
			 };
sleep 1;
//systemChat format ["Missionstatus: %1", _MissionStatus]; // uncomment for debug
};

if(true)exitWith{};
