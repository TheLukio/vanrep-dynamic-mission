if (!isServer) exitWith {}; // Server only

// call functions
call compile preprocessfile "system\sidemissions\functions.sqf";
//[] execVM "f\removeBody\f_addRemoveBodyEH.sqf";
_vehArray = ["I_Heli_Light_03_unarmed_F","I_Heli_Transport_02_F"];

_dir = random 2;
_vehFlyby = _vehArray call BIS_fnc_selectRandom;
_SideHQ = createCenter independent;

switch (_dir) do {
    //cases (insertable by snippet)
    case (1): {
      ambientFly = [getMarkerPos "amb_flyby_2", getMarkerPos "amb_flyby_1", 350, "NORMAL", _vehFlyby, independent] call BIS_fnc_ambientFlyBy;
    };
    case (2): {
      ambientFly = [getMarkerPos "amb_flyby_3", getMarkerPos "amb_flyby_2", 350, "NORMAL", _vehFlyby, independent] call BIS_fnc_ambientFlyBy;
    };
    default {
      ambientFly = [getMarkerPos "amb_flyby_1", getMarkerPos "amb_flyby_3", 200, "NORMAL", _vehFlyby, independent] call BIS_fnc_ambientFlyBy;
    };
};


playSound3D ["A3\Sounds_F\sfx\alarm_independent.wss", base_speakers, false, getPosASL base_speakers, 1, 1, 150];
sleep 5;
playSound3D ["A3\Sounds_F\sfx\alarm_independent.wss", base_speakers, false, getPosASL base_speakers2, 1, 1, 150];
[] execVM "system\sidemissions\f_genVAmbush.sqf"; //uncomment and edit to test different missions
/*
// create missions list array
_allMissions = [];

// check if the mission hasn't executed yet, so add it to missions list array...
if ((side1)) then {
_allMissions pushBack 1;
};
if ((side2)) then {
_allMissions pushBack 2;
};
if ((side3)) then {
_allMissions pushBack 3;
};
if ((side4)) then {
_allMissions pushBack 4;
};
if ((side5)) then {
_allMissions pushBack 5;
};

// find random a mission from missions list array
_missionSelect = (_allMissions call BIS_fnc_selectRandom);
// execute the selected mission...
if (_missionSelect == 1) then { [] execVM "sidemissions\genvambush.sqf";};
if (_missionSelect == 2) then { [] execVM "sidemissions\gensarl.sqf";};
if (_missionSelect == 3) then { [] execVM "sidemissions\gensars.sqf"; };
if (_missionSelect == 4) then { [] execVM "sidemissions\genlminefield.sqf"; };
if (_missionSelect == 5) then { [] execVM "sidemissions\gensminefield.sqf"; };
//if (_missionSelect == 6) then { [] execVM "sidemissions\gensminefield.sqf"; };
*/
