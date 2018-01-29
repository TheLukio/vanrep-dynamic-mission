if (!isServer) exitWith {};

	// set false the side1 so side finder will not execute this mission again
	side1 = false;
	sleep 60;

	// private variables for this script
	private ["_hvtArray","_markerArray", "_centerPos", "_areapos", "_randomPatrolType", "_mrk_pickup", "_mrk_hvt", "_mrk_base", "_trg_hvt_check", "_trg_Cap_hvt", "_trg_hvt_safe","_trg_hvt_done","_hvtMission","_hvtCapture"]; // uncomment _trg if trigger used,

	// define used arrays
	_hvtArray = ["B_G_officer_F", "I_G_resistanceCommander_F","O_officer_F","B_G_Soldier_TL_F"];
	_markerArray = ["aaf_hvt","aaf_hvt_1","aaf_hvt_2","aaf_hvt_3","aaf_hvt_4","aaf_hvt_5","aaf_hvt_6","aaf_hvt_7","aaf_hvt_8","aaf_hvt_9","aaf_hvt_10","aaf_hvt_11"];

// define main lop vars
_hvtMission = true;
_hvtCapture = true;

// define positions
_centerPos = getMarkerPos (_markerArray call BIS_fnc_selectRandom);
_areaPos = [_centerPos, 50 + (random 100), random 360] call BIS_fnc_relPos;
extraction_point = [_centerPos, 10, 50, 3, 0, 2, 0] call BIS_fnc_findSafePos; // global for triggers
/* uav_view = _centerPos; // global for other scripts

// start UAV feed
null = [] execVM "scripts\uavfeed.sqf";sssss
*/

hvtGroup = createGroup west;
hvtGuards = createGroup west;
hvtPatrol1 = createGroup west;
hvtPatrol2 = createGroup west;
hvtPatrol3 = createGroup west;

// spawn hvt & enemies
spawnhvt = (_hvtArray call BIS_fnc_selectRandom) createUnit [ _centerPos, hvtGroup, "hvt = this; this allowFleeing 0; this removeWeapon (primaryWeapon this); this setBehaviour 'Aware';",0.6, "corporal"];
hvtGuards = [_centerPos, west, (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "IRG_ReconSentry")] call BIS_fnc_spawnGroup;
hostage = [hvt addaction ["Take Hostage", { _holder = createVehicle ["GroundWeaponHolder", position cursortarget, [], 0, "CAN_COLLIDE"]; _holder addWeaponCargoGlobal [currentWeapon cursorTarget, 1]; cursorTarget removeWeaponGlobal (currentWeapon cursorTarget); cursortarget action ["Surrender", cursortarget]; cursorTarget setCaptive true; cursorTarget removeAction hostage;}, cursortarget, 6, true, false, "", "cursorTarget isKindOf 'MAN' && player distance hvt < 3"]] spawn BIS_fnc_MP;

//hostage = [[hvt, "Take Hostage", "myScript.sqf", arguments],"TAG_fnc_addactionMP",true,true] spawn BIS_fnc_MP;

_setHvt = [_centerPos, units hvtGroup, 20, false, true,false] execVM "scripts\Zen_OccupyHouse.sqf";
_setHvtGuards = [_centerPos, units hvtGuards, 20, false, true,true] execVM "scripts\Zen_OccupyHouse.sqf";

// settings for hvt - movement, appearance and survivability
hvt addEventHandler ["handleDamage",{ hvt setDamage ((damage hvt) /1.01)}];
hvt forceSpeed 14;
hvt forceWalk true;
removeHeadgear hvt;
hvt addHeadgear "H_MilCap_ocamo";

{
	_x additem "NVGoggles";
	_x assignitem "NVGoggles";
} foreach units hvtGuards;

// Spawn random patrol types

_randomPatrolType = [1,2,3] call BIS_fnc_selectRandom;

switch (_randomPatrolType) do {
    case (1): {
        hvtPatrol1 = [_centerPos, west, (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "IRG_InfAssault")] call BIS_fnc_spawnGroup;
        [hvtPatrol1, _centerPos, 10] call bis_fnc_taskDefend;
        sleep 1;
        hvtPatrol2 = [_centerPos, west, (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "IRG_InfTeam")] call BIS_fnc_spawnGroup;
        [hvtPatrol2, _centerPos, 40] call bis_fnc_taskPatrol;
		[extraction_point, 180, "B_G_Offroad_01_armed_F", hvtPatrol3] call bis_fnc_spawnvehicle;
		[hvtPatrol3, extraction_point, 90] call bis_fnc_taskPatrol;
    };
    case (2): {
        hvtPatrol1 = [_centerPos, west, (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "IRG_InfAssault")] call BIS_fnc_spawnGroup;
        [hvtPatrol1, _centerPos, 20] call bis_fnc_taskDefend;
        sleep 1;
        hvtPatrol2 = [_centerPos, west, (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "IRG_InfTeam")] call BIS_fnc_spawnGroup;
		[hvtPatrol2, _centerPos, 80] call bis_fnc_taskPatrol;
		[extraction_point, 180, "B_G_Offroad_01_armed_F", hvtPatrol3] call bis_fnc_spawnvehicle;
		[hvtPatrol3, extraction_point, 130] call bis_fnc_taskPatrol;
	};
    case (3): {
        hvtPatrol1 = [_centerPos, west, (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "IRG_InfAssault")] call BIS_fnc_spawnGroup;
        [hvtPatrol1, _centerPos, 25] call bis_fnc_taskDefend;
        sleep 1;
        hvtPatrol2 = [_centerPos, west, (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "IRG_InfTeam")] call BIS_fnc_spawnGroup;
		[hvtPatrol2, _centerPos, 100] call bis_fnc_taskPatrol;
		hvtPatrol2 = [_centerPos, west, (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "IRG_InfTeam")] call BIS_fnc_spawnGroup;
		[extraction_point, 180, "B_G_Offroad_01_armed_F", hvtPatrol3] call bis_fnc_spawnvehicle;
		[hvtPatrol3, extraction_point, 150] call bis_fnc_taskPatrol;
	};
};

//create all markers

// create marker for last known position
_mrk_hvt = createMarker ["mrkHvtCap", _areaPos];
_mrk_hvt setMarkerShape "ELLIPSE";
_mrk_hvt setMarkerBrush "Solidborder";
_mrk_hvt setMarkerColor "ColorRed";
_mrk_hvt setMarkerSize [300, 300];
_mrk_hvt setMarkerAlpha 0.5;

// create pickup
_mrk_pickup = createMarker ["mrkHvtPickup", extraction_point];
_mrk_pickup setMarkerShape "ELLIPSE";
_mrk_pickup setMarkerBrush "Solidborder";
_mrk_pickup setMarkerColor "ColorGUER";
_mrk_pickup setMarkerSize [20, 20];
_mrk_pickup setMarkerAlpha 0;

// create marker for mission end
_mrk_base = createMarker ["mrkHvtRet", getmarkerPos "aaf_hq"];
_mrk_base setMarkerShape "ELLIPSE";
_mrk_base setMarkerBrush "Solidborder";
_mrk_base setMarkerColor "ColorGUER";
_mrk_base setMarkerSize [20, 20];



// create triggers
_trg_hvt_check = createTrigger ["EmptyDetector", getPosWorld hvt];
_trg_hvt_check setTriggerArea [10, 10, 0, false];
_trg_hvt_check setTriggerActivation ["ANY", "PRESENT", true];
_trg_hvt_check setTriggerTimeout [5, 5, 0, false];
_trg_hvt_check setTriggerStatements [
"this && captive hvt",
"deleteMarker 'mrkHvtCap';
'mrkHvtPickup' setMarkerAlpha 0.8;
smokeObj = ""G_40mm_SmokePurple"" createvehicle extraction_point;
lightObj = ""Chemlight_green"" createvehicle extraction_point;
hostagegroup = createGroup independent;
[hvt] joinSilent grpNull;
[hvt] joinSilent hostagegroup;",
""
];


_trg_Cap_hvt = createTrigger ["EmptyDetector", extraction_point];
_trg_Cap_hvt setTriggerArea [20, 20, 0, false];
_trg_Cap_hvt setTriggerActivation ["GUER", "PRESENT", true];
_trg_Cap_hvt setTriggerTimeout [5, 5, 0, false];
_trg_Cap_hvt setTriggerStatements [
"this && captive hvt && ((vehicle player) in thislist) && ((vehicle player) isKindOf 'Car' || (vehicle player) isKindOf 'Air');",
"hvt switchmove 'AmovPercMstpSlowWrflDnon';
(units hostagegroup select 0) assignAsCargo (vehicle player);
[(units hostagegroup select 0)] orderGetIn true;",
"['CapHvt1','Succeeded'] call BIS_fnc_taskSetState;
['CapHvt2','Assigned'] call BIS_fnc_taskSetState;
deleteMarker 'mrkHvtPickup'; hvt setcaptive false;"
];

sleep 1;

// create tasks

_taskString0 = format ["Capture High Value Target<br/><br/>- HQ has informed us of a possible enemy high value target at the marked location.<br/><br/>- The high value target must stay alive.<br/><br/>- Several armed personal bodyguards and light patrols are to be expected.<br/><br/>Proceed with caution!"];
_taskDesc0 = "Capture HVT";


[
	"CapHvt0",
	independent,
	[_taskString0, _taskDesc0,""],
	[],
	"CREATED",
	1,
	false,
	true,
	""
] call BIS_fnc_setTask;

_taskString1 = format ["Use any transport available to approach the location. A quiet approach is advised.."];
_taskDesc1 = "Capture";

[
	["CapHvt1","CapHvt0"],
	independent,
	[_taskString1, _taskDesc1,""],
	_areaPos,
	"ASSIGNED",
	1,
	true,
	true,
	"search"
] call BIS_fnc_setTask;

_taskString2 = format ["Return the high value target to your headquarters for interrogation."];
_taskDesc2 = "Retrieve";

[
	["CapHvt2","CapHvt0"],
	independent,
	[_taskString2, _taskDesc2,""],
	getMarkerPos "aaf_gather_land",
	"AUTOASSIGNED",
	2,
	false,
	true,
	"Move"
] call BIS_fnc_setTask;

sleep 1;

// main loop
while {_hvtMission} do {

	// End mission create new random mission
	if (["CapHvt2"] call BIS_fnc_taskCompleted && !(_hvtCapture)) then {
    deleteVehicle hvt;
    {deleteVehicle _x} foreach units hvtGuards;
    {deleteVehicle _x} foreach units hvtPatrol1;
    {deleteVehicle _x} foreach units hvtPatrol2;
    // reset monitor
    _object = Monitor1;
    _object setObjectTextureglobal [0,"scripts\vrstandby.jpg"];
		_hvtMission = false;
		};

	// End mission if hvt dies
	if (!(alive hvt) && !(["CapHvt2"] call BIS_fnc_taskCompleted)) then {
		["CapHvt0","Failed"] call BIS_fnc_taskSetState;
		["CapHvt1","Canceled"] call BIS_fnc_taskSetState;
		["CapHvt2","Failed"] call BIS_fnc_taskSetState;
		sleep 10;
		["CapHvt0",true] call BIS_fnc_deleteTask;
		["CapHvt1",true] call BIS_fnc_deleteTask;
		["CapHvt2",true] call BIS_fnc_deleteTask;
		_hvtMission = false;
	};

	// add action to reassign unit to vehicle
	if (!(hvt in (crew (vehicle player))) && (["CapHvt1"] call BIS_fnc_taskCompleted)) then {
		getinv = hvt addaction ["Get in vehicle.", {sleep 10; (units hostagegroup select 0) assignAsCargo (vehicle player); [(units hostagegroup select 0)] orderGetIn true; cursorTarget removeAction getinv;}, cursortarget, 6, true, false, "", "cursorTarget isKindOf 'MAN' && player distance hvt < 3"];
	};

	if (["CapHvt1"] call BIS_fnc_taskCompleted && _hvtCapture) then {
		 // dismount hostageGroup and move them to gather point
		 _trg_hvt_safe = createTrigger ["EmptyDetector", getMarkerPos "aaf_hq"];
		 _trg_hvt_safe setTriggerArea [50, 50, 0, false];
		 _trg_hvt_safe setTriggerActivation ["GUER", "PRESENT", true];
		 _trg_hvt_safe setTriggerTimeout [10, 10, 10, false];
		 _trg_hvt_safe setTriggerStatements [
		 "this && hvt in (crew (vehicle player)) && ((vehicle player) in thislist);",
		 "hostageGroup leaveVehicle (vehicle player);
		 wpsafe = hostagegroup addWaypoint [(getmarkerpos 'aaf_gather_land'), 0];
		 [hostagegroup,0] setWaypointType 'MOVE';
		 wpsafe setWaypointStatements ['true', '']",
		 "deleteMarker 'mrkHvtRet';"
		 ];

		 // delete all enemies
		 _trg_hvt_done = createTrigger ["EmptyDetector", getMarkerPos "aaf_gather_land"];
		 _trg_hvt_done setTriggerArea [20, 20, 0, false];
		 _trg_hvt_done setTriggerActivation ["GUER", "PRESENT", true];
		 _trg_hvt_done setTriggerStatements [
		 "this && hvt in thislist;",
		 "['CapHvt2','Succeeded'] call BIS_fnc_taskSetState;
		 ['CapHvt0','Succeeded'] call BIS_fnc_taskSetState;",
		 ""
		 ];
		 _hvtCapture = false;
		 sleep 1;
		 if (isserver) then { null=[]execVM "sidefinder.sqf"; };
	};

sleep 5;
};

// go for next side mission


if(true)exitWith{};
