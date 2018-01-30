// Status: Tested SP. No issues. Assault grp only 2 units
if (!isServer) exitWith {};
// set false the side1 so side finder will not execute this mission again
side1 = false;
// private variables for this script
private ["_cleanupObjs","_markerAmbushArray","_vehAmbushArray","_clutterAmbushArray","_centerPos","_extractionPos","_overwatchPos","_transportVeh","_suitableVeh","_pickupType", "_MissionStatus", "_veh", "_source01", "_rndItem","_w1","_w2","_w3","_woundedGroup",  "_IEDGrp","_ambushGrp","_trg_dropoff"]; // uncomment _trg if trigger used

_cleanupObjs = [];

// funcs for cleanup
gatherObj = {
    params ["_objName"];
		_cleanupObjs pushBack _objName;
		_cleanupObjs;
	};

// emplacements
_markerAmbushArray = ["vamb"];
// objects
_vehAmbushArray = ["I_MRAP_03_hmg_F","I_MRAP_03_F","I_Truck_02_covered_F","I_Truck_02_transport_F","I_Truck_02_fuel_F","I_Truck_02_box_F"];
_clutterAmbushArray = ["BloodSplatter_01_Medium_New_F ","BloodPool_01_Medium_New_F","BloodSpray_01_New_F","BloodSplatter_01_Small_New_F","MedicalGarbag_01_Bandage_F","MedicalGarbage_01_FirstAidKit_F","Headgear_H_HelmetIA"];


// spawn vehicle and remove cargo
_centerPos = getMarkerPos (_markerAmbushArray call BIS_fnc_selectRandom);

// find extraction point
_extractionPos = [_centerPos, 10, 50, 3, 0, 2, 0] call BIS_fnc_findSafePos;

// find overwatch Position
_overwatchPos = [_centerPos, 300, 150, 10] call BIS_fnc_findOverwatch;

// define variables for main loop
_pickupType = "truck_f"; // What TYPEOF vehicle should do the pickup?

private _MissionStatus = 0;

		// mission set up stage
			waitUntil {_MissionStatus == 0};

			// create ambushed vehicles
			_veh = _vehAmbushArray call BIS_fnc_selectRandom;
			_veh = _veh createVehicle _centerPos;
			_veh setVehicleLock "LOCKED";
			_veh animateDoor ["Door_LF", 1, true];
			_veh animateDoor ["Door_RF", 1, true];
			_veh setPilotLight true;
			// remove all items from veh
			clearBackpackCargoGlobal _veh;
			clearWeaponCargoGlobal  _veh;
			clearMagazineCargoGlobal _veh;
			[_veh] call gatherObj;


			// set damage to vehicle
			_veh setHit [getText(configFile >> "cfgVehicles" >> (typeOf _veh) >> "HitPoints" >> "HitGlass1" >> "name"),0.7];
			_veh setHit [getText(configFile >> "cfgVehicles" >> (typeOf _veh) >> "HitPoints" >> "HitRFWheel" >> "name"),1];
			_veh setHit [getText(configFile >> "cfgVehicles" >> (typeOf _veh) >> "HitPoints" >> "HitRF2Wheel" >> "name"),1];
			_veh setHit [getText(configFile >> "cfgVehicles" >> (typeOf _veh) >> "HitPoints" >> "HitRF2Wheel" >> "name"),1];
			_veh setHit [getText(configFile >> "cfgVehicles" >> (typeOf _veh) >> "HitPoints" >> "HitEngine" >> "name"),1];
			_veh setHit [getText(configFile >> "cfgVehicles" >> (typeOf _veh) >> "HitPoints" >> "HitBody" >> "name"),1];

			// create smoke emitter at vehicle
			_source01 = "#particlesource" createVehicle getPosWorld _veh;
			_source01 setParticleClass "UAVWreckSmoke";
			_source01 attachto [_veh,[0,1,-1]];

			[_source01] call gatherObj;

			// create wounded soldiers
			_woundedGroup = createGroup [independent,true];
			_w1 = _woundedGroup createUnit ["I_Soldier_TL_F", getPosATL _veh, [], 15, "FORM"];
			_w2 = _woundedGroup createUnit ["I_Soldier_F", getPosATL _veh, [], 11, "NONE"];
			_w3 = _woundedGroup createUnit ["I_Soldier_F", getPosATL _veh, [], 19, "NONE"];
			[_w1,_w2,_w3] join _woundedGroup;
			(group (leader _woundedGroup)) setVariable ["f_cacheExcl", true];


			waituntil {count units _woundedgroup > 2};

			// make survivors unconcious and give player the ability to "revive"
			{
			_x setCaptive true;
			removeAllAssignedItems _x;
			removeAllWeapons _x;
			_x unassignItem "FirstAidKit";
			_x removeItem "FirstAidKit";
			_x setDamage 0.9;
			_x playAction "AgonyStart";
			_x allowFleeing 0;
			removeHeadgear _x;
			_rndItem = createVehicle [(_clutterAmbushArray call BIS_fnc_selectRandom), getPosATL _x, [], 1.5, "CAN_COLLIDE"];
			//_rndItem setPosATL (getPosATL _x select 0 + ,);
		 	[_rndItem] call gatherObj;
			[
			_x,
			"Give First Aid",
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa",
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa",
			"_this distance _target < 3","true",
			{hint "Applying first aid";},
			{},
			{_target setDamage 0; _target playAction "AgonyStop"; _target setVariable ["healed", true]; _target setunitpos "MIDDLE"; },
			{hint "Stopped first aid"},
			[],
			10,
			nil,
			true,
			true
			] remoteExec ["BIS_fnc_holdActionAdd",[0,-2] select isDedicated,true];

			} forEach units _woundedGroup;

			waitUntil {{alive _X} count (units _woundedGroup) > 0};
			// create small force that placed IED
			_IEDGrp = createGroup [west,true];
			_IEDGrp = [ ( [_centerPos, 50 + (random 70), random 360] call BIS_fnc_relPos), west, (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "IRG_ReconSentry")] call BIS_fnc_spawnGroup;
			//[_IEDGrp, _centerPos, (random 50)] call BIS_fnc_taskDefend;
			(group (leader _IEDGrp)) setVariable ["f_cacheExcl", true];
			_IEDGrp allowFleeing 0;
			_IEDGrp setBehaviour "COMBAT";
			_IEDGrp setSpeedMode "LIMITED";

			// ied group wps
			_IEDGrp addWaypoint [_extractionPos, 30];
			[_IEDGrp, 0] setWaypointType "SENTRY";
			[_IEDGrp, 0] setWaypointCombatMode "RED";

			waitUntil {{alive _X} count (units _IEDGrp) > 0};
			// create large(r) ambush force
			_ambushGrp = createGroup [west,true];
			//_ambushGrp = [_overwatchPos, west, ["B_G_Soldier_TL_F","B_G_Soldier_F", "B_G_Soldier_F", "B_G_Soldier_AR_F", "B_G_Soldier_LAT_F"]] call BIS_fnc_spawnGroup;
			_ambushGrp = [_overwatchPos, west, ["B_G_Soldier_F", "B_G_Soldier_F"]] call BIS_fnc_spawnGroup;
			(group (leader _ambushGrp)) setVariable ["f_cacheExcl", true];
			_ambushGrp allowFleeing 0;
			_ambushGrp setBehaviour "STEALTH";
			_ambushGrp setSpeedMode "NORMAL";

			// enemy groups wps
			_ambushGrp addWaypoint [_overwatchPos, 20];
			[_ambushGrp, 0] setWaypointType "HOLD";
			[_ambushGrp, 0] setWaypointCombatMode "WHITE";
			[_ambushGrp, 0] setWaypointBehaviour "STEALTH";
			[_ambushGrp, 0] setWaypointSpeed "NORMAL";
			[_ambushGrp, 0] setWaypointFormation "LINE";
			[_ambushGrp, 0] setWaypointStatements ["true", "{_x setunitpos ""DOWN""} foreach units _ambushGrp;"];


			waitUntil {{alive _X} count (units _ambushGrp) > 0};
			hint "Assigning tasks";
			// create tasks
			 private _taskString1 = "Rescue AAF forces<br/><br/>- A routine AAF patrol has been hit by an IED.<br/><br/> Enemy forces may be in the vicinity.<br/><br/> Secure the area and provide first aid.";
			 private _taskDesc1 = "Combat rescue AAF patrol (Land)";
			 private _taskString2 = "Extract the soldiers via helicopter.";
			 private _taskDesc2 = "Recover AAF soldiers (Land)";

			[independent,["task1"],[_taskString1, _taskDesc1, "marker"],_centerPos,1,1,true,"defend",false] call BIS_fnc_taskCreate;
			[independent,["task2"],[_taskString2, _taskDesc2, "marker"],"aaf_gather_land",0,2,true,"walk",false] call BIS_fnc_taskCreate;

		// create AO Marker
			["mrkAOVamb",_centerPos,100,100,"ELLIPSE","ColorRed"] execVM "system\functions\f_fnc_mrkCreate.sqf";

		_MissionStatus = 1;  // setup complete wait for players to interact

  	// continue mission once all survivors are healed
		waitUntil { {_x getVariable "healed"} forEach units _woundedGroup}; // wait for all friendly units healed
		{
		_x setCaptive false;
		_x setunitpos "Middle";
		_x setCombatMode "Blue";
		} forEach units _woundedGroup;

		// let ambushgrp attack
		_ambushGrp addWaypoint [_centerPos, 50];
		[_ambushGrp, 1] setWaypointType "DESTROY";
		[_ambushGrp, 1] setWaypointCombatMode "YELLOW";
		[_ambushGrp, 1] setWaypointBehaviour "COMBAT";
		[_ambushGrp, 1] setWaypointSpeed "FULL";
		[_ambushGrp, 1] setWaypointFormation "VEE";
		leader _ambushGrp commandSuppressiveFire _centerPos;
		[_ambushGrp, 1] setWaypointForceBehaviour true;
		_ambushGrp allowFleeing 0;


		waitUntil { ( ({alive _x} count (units _ambushGrp)) == 0) && ( ({alive _x} count (units _IEDGrp)) == 0) }; // wait for all spawned enemies dead

		deleteMarker "mrkAOVamb";

		// create wp for wounded soldiers group
		_woundedGroup addWaypoint [_extractionPos, 15];
		[_woundedGroup, 0] setWaypointType "MOVE";
		[_woundedGroup, 0] setWaypointSpeed "Normal";
		[_woundedGroup, 0] setWaypointBehaviour "AWARE";
		[_woundedGroup, 0] setWaypointStatements ["true", "{_x setunitpos ""MIDDLE""} foreach units _woundedGroup;"];
		[_woundedGroup, 0] setWaypointForceBehaviour true;

		private _smokeObj = "SmokeShellPurple_Infinite" createvehicle _extractionPos;
		private _lightObj = "IRStrobeBase" createvehicle _extractionPos;

		["mrkExtractVamb",_extractionPos,15,15,"ELLIPSE","colorIndependent"] execVM "system\functions\f_fnc_mrkCreate.sqf";

		if ( {alive _x} count (units _woundedGroup) > 0 ) then {

			['task1','Succeeded'] call BIS_fnc_taskSetState;
			['task2','Assigned'] call BIS_fnc_taskSetState;
			// add check for pilots - if available create pickup mission
			waitUntil {((units _woundedGroup) select 0) distance _extractionPos < 15};
			_MissionStatus = 2;
			}
			else {
				['task1','Failed'] call BIS_fnc_taskSetState;
				['task2','Canceled'] call BIS_fnc_taskSetState;
				// End Mission
				// Despawn groups / vehs
				// Task RTB
				// exit
			};



			// begin extraction phase precheck
			while {_MissionStatus == 2} do {

				// check for suitable vehicles with enough cargo space
				_suitableVeh = vehicles inAreaArray [_extractionPos, 25, 25, 0, false, 50] select {_x emptyPositions "cargo" > 2}; //== ({alive _x} count units _woundedgroup)};
			// check if vehicle selected matches cargo type
				_transportVeh = _suitableVeh select {_x isKindOf _pickupType}; // _pickupType = "helicopter" / "Truck_F" / "Car"

				// vehicle suitable and matches _pickupType
				if (count _transportVeh > 0 ) exitWith {

						private _groupToCargo = [_transportVeh,_woundedGroup] call compile preprocessFileLineNumbers "system\functions\f_groupAssignCargo.sqf";
						// call _groupToCargo function for units to get in (f_groupAssignCargo.sqf);
						waitUntil {_groupToCargo};

						// units are in vehicle, get rid of markers / objects
						deleteMarker "mrkExtractVamb";
            for "_i" from 0 to 3 do {
              deleteMarker format["mrkExtractVamb%1",_i];
            };
						deleteVehicle _smokeObj;
						deleteVehicle _lightObj;

						//create dropoff trigger
						_trg_dropoff = createTrigger ["EmptyDetector", (getMarkerPos "aaf_hq")];
						_trg_dropoff setTriggerArea [250, 250, 0, false, 5];
						_trg_dropoff triggerAttachVehicle [(units _woundedgroup select 0)];
						_trg_dropoff setTriggerActivation ["GROUP", "PRESENT", true];
						_trg_dropoff setTriggerTimeout [3, 3, 0, false];
						_trg_dropoff setTriggerStatements [
						"this",
						format ["systemChat 'triggered by %1'",triggerAttachedVehicle _trg_dropoff],
						""w
						];
						[_trg_dropoff] call gatherObj;
						_MissionStatus = 3;
				};
		};
			// dismount survivors move to aaf gather land
				waituntil {_MissionStatus == 3 && triggeractivated _trg_dropoff};

					{ unassignVehicle _x } forEach units _woundedgroup;
					{_x setunitpos "UP"} foreach units _ambushGrp;
					_woundedGroup leaveVehicle (vehicle player);
					_woundedgroup addWaypoint [(getmarkerpos 'aaf_gather_land'), 1];
					[_woundedGroup, 1] setWaypointStatements ["true",""];
					[_woundedGroup, 1] setWaypointType 'MOVE';
					[_woundedGroup, 1] setWaypointBehaviour "CARELESS";
					[_woundedGroup, 1] setWaypointSpeed "NORMAL";
					[_woundedGroup, 1] setWaypointCompletionRadius 20;

				waitUntil {unitReady (leader _woundedGroup )};

				['task2','Succeeded'] call BIS_fnc_taskSetState;
				{{deleteVehicle _x} forEach units _X} forEach [_woundedGroup,_IEDgrp,_ambushGrp] ;
 			 	{deleteVehicle _x} forEach _cleanupObjs;
				["task1",true] call BIS_fnc_deleteTask;
				["task2",true] call BIS_fnc_deleteTask;

				// return to sidefinder for new mission.
				if (isserver) then { null=[]execVM "system\sidefinder.sqf"; };
