/*
GENERATE MINEFIELD (LAND)
Generate minefield at random location, create barriers around minefield.
Task units to clear minefield by deactivating all mines in the area.
Random chance of sniper team ambushing eod teams.
*/

if (!isServer) exitWith {};

// set false so side finder will not execute this mission again
side4 = false;

// private variables for this script
private ["_mineWarnObj","_mineTypeObj", "_landMineArray", "_markerlandMineArray","_randomSniperChance","_minesArray", "_vehArray","_centerPos","_sniperspresent","_veh","_taskString0","_taskDesc0","_mrk_sad","_lmineMission","_MissionStatus"]; // uncomment _trg if trigger used

// objects
_mineWarnObj = "Land_Sign_Mines_F";
_mineTypeObj = "Apersmine";

// arrays
_landMineArray = ["TapeSign_F","PlasticBarrier_03_orange_F","RoadBarrier_F","Land_CncBarrier_stripes_F"];
_markerlandMineArray = ["lmine","lmine_1","lmine_2","lmine_3","lmine_4","lmine_5","lmine_6","lmine_7","lmine_8","lmine_9","lmine_10","lmine_11","lmine_12","lmine_13","lmine_14","lmine_15","lmine_16"];
_randomSniperChance = [1,0,1,1,0,0,1,1,0,0];
_minesArray = [];
_vehArray = [];

// get random values from arrays
_centerPos = getMarkerPos (_markerlandMineArray call BIS_fnc_selectRandom);
_sniperspresent = _randomSniperChance call BIS_fnc_selectRandom;
_veh = _landMineArray call BIS_fnc_selectRandom;

sleep 0.1;

// call function to create AO marker
nul = [50,50,"ColorRed",_centerPos,"ELLIPSE"] spawn SM_fn_createMarker; // create marker for last known position

// create task
 _taskString0 = format ["Civilians have located and marked a suspected minefield.<br/>Use a minesweeper to detect mines<br/>Use a toolkit to disable all mines in the area<br/><br>Possible enemy activity in the vicinity."];
 _taskDesc0 = "Clear Minefield (LAND)";
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

// define variables for main loop
_lmineMission = true;
_MissionStatus = 0;

// main loop
while { _lmineMission} do {

    // spawn mines
		if ( _MissionStatus == 0 ) then {
			// foreach loop
      _mineWarning = createVehicle [_mineWarnObj, _centerPos, [], 0, "CAN_COLLIDE"];
      _mineWarning2 = createVehicle [_mineWarnObj, _centerPos, [], 0, "CAN_COLLIDE"];
      _mineWarning2 setDir 180;
       _vehArray pushBack _mineWarning;
       _vehArray pushBack _mineWarning2;
      _i = 0;
      for [{_i=0}, {_i<15}, {_i=_i+1}] do
      {
          _mineName = createMine [_mineTypeObj , _centerPos, [], 15];
          _minesArray pushBack _mineName;
      };
      _i2 = 0;
      for [{_i2=1}, {_i2<17}, {_i2=_i2+1}] do
      {
          _radiusDir = _i2 * 22.5;
          _flagPos = [_centerPos, 16, _radiusDir] call BIS_fnc_relPos;
          _barrier = createVehicle [_veh, _flagpos, [], 0, "CAN_COLLIDE"];
          _barrier enableSimulation false;
          _barrier setDir _radiusDir;
          _vehArray pushBack _barrier;
      };
      _MissionStatus = 1;
		};

		if (( _MissionStatus == 1 ) && ( { mineActive _x }count _minesArray <= 9 )) then {
        // create random chance of a enemy team
        systemChat format ["Snipers present? %1", _sniperspresent]; // uncomment for debug
      if ( _sniperspresent == 1) then {
          _overwatchPos = [_centerPos, 250, 150, 10] call BIS_fnc_findOverwatch;
          _sniperGrp = createGroup west;
          _sniperGrp = [_overwatchPos, west, (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "IRG_SniperTeam_M")] call BIS_fnc_spawnGroup;
          (group (leader _sniperGrp)) setVariable ["f_cacheExcl", true];
          [_sniperGrp] spawn SM_fn_setskill;

          // set sniper team to stealth and open fire
          _wp =_sniperGrp addWaypoint [_centerPos, 5];
          [_sniperGrp, 1] setWaypointType "SAD";
          [_sniperGrp, 1] setWaypointCombatMode "YELLOW";
          [_sniperGrp, 1] setWaypointBehaviour "COMBAT, STEALTH";
          [_sniperGrp, 1] setWaypointSpeed "NORMAL";
          [_sniperGrp, 1] setWaypointFormation "LINE";
          [_sniperGrp, 1] setWaypointStatements ["true", "{_x setunitpos ""DOWN""} foreach units _sniperGrp;"];
          sleep 1;
          _MissionStatus = 2;
    		}
        else {
          _MissionStatus = 2;
        };
			};

      if ( _MissionStatus == 2 ) then {
        if ( { mineActive _x }count _minesArray == 0 ) exitWith {
          _MissionStatus = 3;
    		};
			};

			 if ( _MissionStatus == 3)  then {
          // Mission cleanup
          [
              "GroundWeaponHolder",
              "WeaponHolderSimulated",
              "WeaponHolder",
              "CraterLong",
              "Ruins",
              "#smokesource",
              "#destructioneffects"
          ] spawn SM_fn_clenaup;
          sleep 0.1;
          {deleteVehicle _x} forEach _vehArray;
          sleep 0.1;
          if !(isNil "_sniperGrp") then {
          {deleteVehicle _x} forEach units _sniperGrp;
          deleteGroup _sniperGrp;
          nul = [] spawn SM_fn_delMarker;
          sleep 0.1;
          };
          // Main task succeeded, delete task
          ['LMineClear0','Succeeded'] call BIS_fnc_taskSetState;
          sleep 5;
          ["LMineClear0",true] call BIS_fnc_deleteTask;
          //_rtb = [] call SM_fn_rtb;
          _lmineMission = false;
          sleep 1;
          if (isserver) then { null=[]execVM "sidefinder.sqf"; };
			 };
sleep 1;
};



if(true)exitWith{};
