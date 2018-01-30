if (!isServer) exitWith {}; // Server only

private ["_missionTime"];
// call functions
//call compile preprocessfile "system\sidemissions\functions.sqf";
//[] execVM "f\removeBody\f_addRemoveBodyEH.sqf";
[] execVM "system\functions\f_ambientHelos.sqf";


_missionTime = time + 120;
waitUntil {time >= _missionTime};

createcenter independent;

playSound3D ["A3\Sounds_F\sfx\alarm_independent.wss", base_speakers, false, getPosASL base_speakers, 3, 0.7, 100];
sleep 2;
playSound3D ["A3\Sounds_F\sfx\alarm_independent.wss", base_speakers, false, getPosASL base_speakers2, 3, 0.7, 100];
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
