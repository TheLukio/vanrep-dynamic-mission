// Status: Tested SP. No issues. Assault grp only 2 units

if (!isServer) exitWith {};
// set false the side1 so side finder will not execute this mission again
side1 = false;
// private variables for this script
private ["_ambushMission","_vehAmbushArray","_markerAmbushArray", "_woundedArray", "_centerPos", "_veh", "_source01", "_w1","_w2","_w3","_woundedGroup", "_extraction_point", "_overwatchPos", "_IEDGrp","_ambushGrp","_nearUnits","_trg_pickup","_trg_dropoff","_mrk_sad"]; // uncomment _trg if trigger used
_vehAmbushArray = ["I_MRAP_03_hmg_F","I_MRAP_03_F","I_Truck_02_covered_F","I_Truck_02_transport_F","I_Truck_02_fuel_F","I_Truck_02_box_F"];
_markerAmbushArray = ["vamb","vamb_1","vamb_2","vamb_3","vamb_4","vamb_5","vamb_6","vamb_7","vamb_8","vamb_9","vamb_10","vamb_11","vamb_12","vamb_13"];

// spawn vehicle and remove cargo
_centerPos = getMarkerPos (_markerAmbushArray call BIS_fnc_selectRandom);
// find extraction point
_extraction_point = [_centerPos, 10, 50, 3, 0, 2, 0] call BIS_fnc_findSafePos;

// find over watchPosition
_overwatchPos = [_centerPos, 400, 150, 10] call BIS_fnc_findOverwatch;

// define variables for main loop
_ambushMission = true;
_MissionStatus = 0;
vehpickup = "none";
FinishedMoving = false;

// main loop
while {_ambushMission} do {

		if ( _MissionStatus == 0 ) then {
			// create ambushed vehicles
			_veh = _vehAmbushArray call BIS_fnc_selectRandom;
			_veh = _veh createVehicle _centerPos;
			_veh setVehicleLock "LOCKED";
			clearBackpackCargoGlobal _veh;
			clearWeaponCargoGlobal  _veh;
			clearMagazineCargoGlobal _veh;
			_veh animateDoor ["Door_LF", 1, true];
			_veh animateDoor ["Door_RF", 1, true];
			_veh setPilotLight true;

			// set damage to vehicle
			_veh setHit [getText(configFile >> "cfgVehicles" >> (typeOf _veh) >> "HitPoints" >> "HitGlass1" >> "name"),0.7];
			_veh setHit [getText(configFile >> "cfgVehicles" >> (typeOf _veh) >> "HitPoints" >> "HitRFWheel" >> "name"),1];
			_veh setHit [getText(configFile >> "cfgVehicles" >> (typeOf _veh) >> "HitPoints" >> "HitRF2Wheel" >> "name"),1];
			_veh setHit [getText(configFile >> "cfgVehicles" >> (typeOf _veh) >> "HitPoints" >> "HitRF2Wheel" >> "name"),1];
			_veh setHit [getText(configFile >> "cfgVehicles" >> (typeOf _veh) >> "HitPoints" >> "HitEngine" >> "name"),1];
			_veh setHit [getText(configFile >> "cfgVehicles" >> (typeOf _veh) >> "HitPoints" >> "HitBody" >> "name"),1];


			_veh enableSimulation false;

			// create smoke emitter at vehicle
			_source01 = "#particlesource" createVehicle getPosWorld _veh;
			_source01 setParticleClass "UAVWreckSmoke";
			_source01 attachto [_veh,[0,1,-1]];

			// create wounded soldiers
			_woundedGroup = createGroup independent;
			_w1 = _woundedGroup createUnit ["I_Soldier_TL_F", getPosATL _veh, [], 15, "CORPORAL"];
			_w2 = _woundedGroup createUnit ["I_Soldier_F", getPosATL _veh, [], 12, "NONE"];
			_w3 = _woundedGroup createUnit ["I_Soldier_F", getPosATL _veh, [], 18, "NONE"];
			[_w1,_w2,_w3] join _woundedGroup;
			_woundedGroup allowFleeing 0;
			(group (leader _woundedGroup)) setVariable ["f_cacheExcl", true];


			// make survivors unconcious and give player the ability to "revive"
			{
			_x setCaptive true;
			removeAllAssignedItems _x;
			removeAllWeapons _x;
			_x unassignItem "FirstAidKit";
			_x removeItem "FirstAidKit";
			_x setDamage 0.9;
			_x playAction "AgonyStart";
			[
			_x,
			"Give First Aid",
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa",
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa",
			"_this distance _target < 3","true",
			{hint "Applying first aid";},
			{},
			{_target setDammage 0; _target playAction "AgonyStop";},
			{hint "Stopped first aid"},
			[],
			10,
			nil,
			true,
			true
			] remoteExec ["BIS_fnc_holdActionAdd",[0,-2] select isDedicated,true];

			} forEach units _woundedGroup;

			// create small force that exploded IED
			_IEDGrp = createGroup west;
			_IEDGrp = [ ( [_centerPos, 50 + (random 70), random 360] call BIS_fnc_relPos), west, (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "IRG_ReconSentry")] call BIS_fnc_spawnGroup;
			//[_IEDGrp, _centerPos, (random 50)] call BIS_fnc_taskDefend;
			(group (leader _IEDGrp)) setVariable ["f_cacheExcl", true];
			_IEDGrp allowFleeing 0;
			_IEDGrp setBehaviour "COMBAT";
			_IEDGrp setSpeedMode "LIMITED";

			// ied group wps
			_wpsentry =_IEDGrp addWaypoint [_extraction_point, 30];
			[_IEDGrp, 0] setWaypointType "SENTRY";
			[_IEDGrp, 0] setWaypointCombatMode "RED";



			// create large(r) ambush force
			_ambushGrp = createGroup west;
			//_ambushGrp = [_overwatchPos, west, ["B_G_Soldier_TL_F","B_G_Soldier_F", "B_G_Soldier_F", "B_G_Soldier_AR_F", "B_G_Soldier_LAT_F"]] call BIS_fnc_spawnGroup;
			_ambushGrp = [_overwatchPos, west, ["B_G_Soldier_F", "B_G_Soldier_F"]] call BIS_fnc_spawnGroup;
			(group (leader _ambushGrp)) setVariable ["f_cacheExcl", true];
			_ambushGrp allowFleeing 0;
			_ambushGrp setBehaviour "STEALTH";
			_ambushGrp setSpeedMode "NORMAL";

			// enemy groups wps
			_wphold =_ambushGrp addWaypoint [_overwatchPos, 20];
			[_ambushGrp, 0] setWaypointType "HOLD";
			[_ambushGrp, 0] setWaypointCombatMode "WHITE";
			[_ambushGrp, 0] setWaypointBehaviour "STEALTH";
			[_ambushGrp, 0] setWaypointSpeed "NORMAL";
			[_ambushGrp, 0] setWaypointFormation "LINE";
			[_ambushGrp, 0] setWaypointStatements ["true", "{_x setunitpos ""DOWN""} foreach units _ambushGrp;"];

			// set skill for spawned groupSelectedUnits
			[_IEDGrp] spawn SM_fn_setskill;
			[_ambushGrp] spawn SM_fn_setskill;

			// create tasks
			 _taskString1 = "Rescue AAF forces<br/><br/>- A routine AAF patrol has been hit by an IED.<br/><br/> Enemy forces may be in the vicinity.<br/><br/> Secure the area and provide first aid.";
			 _taskDesc1 = "Combat rescue AAF patrol (Land)";

			 _taskString2 = "Extract the soldiers via helicopter.";
			 _taskDesc2 = "Recover AAF soldiers (Land)";

			[independent,["task1"],[_taskString1, _taskDesc1, "marker"],_centerPos,1,1,true,"defend",false] call BIS_fnc_taskCreate;
			[independent,["task2"],[_taskString2, _taskDesc2, "marker"],"aaf_gather_land",0,2,true,"walk",false] call BIS_fnc_taskCreate;


            // create dropoff trigger
            _trg_dropoff = createTrigger ["EmptyDetector", (getMarkerPos "aaf_hq")];
            _trg_dropoff setTriggerArea [250, 250, 0, false, 5];
            _trg_dropoff triggerAttachVehicle [vehicle (units _woundedgroup select 0)];
            _trg_dropoff setTriggerActivation ["MEMBER", "PRESENT", true];
            _trg_dropoff setTriggerTimeout [3, 3, 0, false];
            _trg_dropoff setTriggerStatements [
            "isServer && ((vehicle player) in thisList) && (vehicle player) isKindOf 'Air'",
            "",
            ""
            ];

			// create AO Marker
			[150,150,"ColorRed",_centerPos,"ELLIPSE"] spawn SM_fn_createMarker;

			_MissionStatus = 1;
		};

		// if all 3 wounded solders are healed let them stand up
		if ( _MissionStatus == 1 ) then {

		        // continue mission once all survivors are healed
		waitUntil {{(lifeState _x == "HEALTHY")} count units _woundedGroup == count units _woundedGroup};
		{
		_x setCaptive false;
		_x setunitpos "Middle";
		_x setCombatMode "Blue";
		sleep 0.1;
		} forEach units _woundedGroup;

		// create wp for wounded soldiers group
		_wpextract = _woundedGroup addWaypoint [_extraction_point, 15];
		[_woundedGroup, 0] setWaypointType "MOVE";
		[_woundedGroup, 0] setWaypointSpeed "Normal";
		[_woundedGroup, 0] setWaypointBehaviour "AWARE";
		[_woundedGroup, 0] setWaypointStatements ["true", "{_x setunitpos ""MIDDLE""} foreach units _woundedGroup;"];

		// let ambushgrp attack
		_wpattack =_ambushGrp addWaypoint [_centerPos, 50];
		[_ambushGrp, 1] setWaypointType "DESTROY";
		[_ambushGrp, 1] setWaypointCombatMode "YELLOW";
		[_ambushGrp, 1] setWaypointBehaviour "COMBAT, STEALTH";
		[_ambushGrp, 1] setWaypointSpeed "FULL";
		[_ambushGrp, 1] setWaypointFormation "VEE";
		[_ambushGrp, 1] setWaypointStatements ["true", "{_x setunitpos ""MIDDLE""} foreach units _ambushGrp;"];
		leader _ambushGrp commandSuppressiveFire _centerPos;
		sleep 0.1;
		_MissionStatus = 2;
		};
			// check if evac is not active and all enemies in vicinity dead, then create marker & send wounded soldiers to evac point

		if (_MissionStatus == 2) then {
			if ( ( ({alive _x} count (units _ambushGrp)) < 2) && ( ({alive _x} count (units _IEDGrp)) < 1) ) then {
			['task1','Succeeded'] call BIS_fnc_taskSetState;
			['task2','Assigned'] call BIS_fnc_taskSetState;
				_MissionStatus = 3;
			};
		};

		if (_MissionStatus == 3) then {

			// remove AO marker
			nul = [] spawn SM_fn_delMarker;

			// create pickup marker
			_extract = createMarker ["extract", _extraction_point];
			"extract" setMarkerType "mil_pickup";
			"extract" setMarkerColor "ColorGUER";

			if ( ( ({alive _x} count (units _ambushGrp)) < 2) && ( ({alive _x} count (units _IEDGrp)) < 1) ) then {
				_MissionStatus = 4;
			};
		};

		if ( _MissionStatus == 4 ) then {
			_nearUnits = _extraction_point nearEntities 50;
			if ((vehicle player in _nearUnits) && ((vehicle player) isKindOf "AIR")) then {
			lightObj = "Chemlight_green" createvehicle _extraction_point;
			smokeObj = "G_40mm_SmokePurple" createvehicle _extraction_point;
			{ _x assignAsCargo vehicle player;} forEach units _woundedGroup;
            (units _woundedGroup) orderGetIn true;
				if  ( {_x in (vehicle player)} count (units _woundedGroup) == count (units _woundedGroup) ) then {
				// set primary task succeeded, assign scondaryss
				_MissionStatus = 5;
				};
			};
		};

		if ( _MissionStatus == 5 ) then {

			if (({ !(alive _x) || _x distance (getMarkerPos "aaf_gather_land") < 250 } count (units _woundedGroup)) == count (units _woundedGroup) ) then {
				deleteMarker "mrkWSPickup";
				deleteVehicle lightobj;
				deleteVehicle smokeObj;
				sleep 0.1;
			};
			   // dismount survivors move to aaf gather land
			if (triggeractivated _trg_dropoff) then {
				{ unassignVehicle _x } forEach units _woundedgroup;
				_woundedGroup leaveVehicle (vehicle player);
				_wpsafe = _woundedgroup addWaypoint [(getmarkerpos 'aaf_gather_land'), 1];
				[_woundedGroup, 1] setWaypointStatements ["true", "FinishedMoving = true;"];
				[_woundedGroup, 1] setWaypointType 'MOVE';
				[_woundedGroup, 1] setWaypointBehaviour "CARELESS";
				[_woundedGroup, 1] setWaypointSpeed "FULL";
				[_woundedGroup, 1] setWaypointCompletionRadius 10;
			};

		    if ( FinishedMoving ) then {
				['task2','Succeeded'] call BIS_fnc_taskSetState;
				_MissionStatus = 6;
			};

		};

		if ( _MissionStatus == 6 ) then {
			if (({alive _x} count units _woundedgroup) > 0) then {
				FinishedMoving = nil;
				{deleteVehicle _x} forEach units _woundedGroup;
				{deleteVehicle _x} forEach units _ambushGrp;
				{deleteVehicle _x} forEach units _IEDGrp;
				deleteGroup _woundedGroup;
				deleteGroup _ambushGrp;
				deleteGroup _IEDGrp;
				deleteMarker "extract";
				deleteVehicle _veh;
				deleteVehicle _trg_dropoff;
				sleep 5;
				["task1",true] call BIS_fnc_deleteTask;
				["task2",true] call BIS_fnc_deleteTask;
				 sleep 0.1;
				_ambushMission = false;
				if (isserver) then { null=[]execVM "sidefinder.sqf"; };
        	};
		};


		if ((( _MissionStatus > 2 ) || ( _MissionStatus < 6 )) && (({alive _x} count units _woundedGroup) == 0)) then {
			["task1","Failed"] call BIS_fnc_taskSetState;
			["task2","Failed"] call BIS_fnc_taskSetState;
			_MissionStatus = 6;
			if (isserver) then { null=[]execVM "sidefinder.sqf"; };
			_ambushMission = false;
		};
		sleep 1;
		//systemChat format ["Missionstatus: %1", _MissionStatus]; // uncomment for debug
};

if(true)exitWith{};
