if (!isServer) exitWith {};
side3 = false; // set false the side1 so sidefinder will not execute this mission again

private ["_civArray","_vehArray","_markerArray", "_boatPos","_survivorspos","_veh","_veh2","_taskString0","_taskString1","_taskString2","_survivors","_myUnitCount", "_centerPos", "_survivors","_trg_dropoff","_source01","_flrObj1","_flrObj","_ssarMission","_MissionStatus","_tod","_nearCamp"];

_civArray = ["C_man_polo_1_F_afro","C_man_polo_2_F_euro","C_man_polo_1_F_asia","C_man_polo_4_F_euro","C_man_p_fugitive_F_euro","C_man_hunter_1_F","C_man_polo_5_F_euro"," C_man_polo_2_F_afro"];
_vehSarArray = ["C_Boat_Civil_01_F","C_Rubberboat","B_Lifeboat","C_Boat_Transport_02_F","C_Scooter_Transport_01_F"];
_markerArray = ["aaf_sar1","aaf_sar1_2","aaf_sar1_3","aaf_sar1_4","aaf_sar1_5","aaf_sar1_6","aaf_sar1_7","aaf_sar1_8","aaf_sar1_9","aaf_sar1_10","aaf_sar1_10_1"];

_centerPos = getMarkerPos (_markerArray call BIS_fnc_selectRandom);
_boatPos = [_centerPos, 175 + (random 675), random 360] call BIS_fnc_relPos;
_survivorspos = [_boatPos, 75 + (random 75) , random 360] call BIS_fnc_relPos;


// define variables for main loop
_ssarMission = true;
FinishedMoving = false;
_MissionStatus = 0;

// main loop
while {_ssarMission} do {
    // missionstatus 0
		if ( _MissionStatus == 0 ) then {
        // create survivors boat
        _veh = (_vehSarArray call BIS_fnc_selectRandom) createVehicle _boatPos;
        _veh setVehicleLock "LOCKED";
		_veh2 = "Land_balloon_01_air_F" createVehicle _survivorspos;

        // Add light smoke to vehicle
        _source01 = "#particlesource" createVehicle getPosWorld _veh;
        _source01 setParticleClass "UAVWreckSmoke";
        _source01 attachto [_veh,[0,-1,-1]];

        // create civilians nearby
        _survivors = createGroup independent;
        _survivors = [ _survivorspos, civilian, [_civArray call BIS_fnc_selectRandom, _civArray call BIS_fnc_selectRandom, _civArray call BIS_fnc_selectRandom, _civArray call BIS_fnc_selectRandom],[],[],[],[],[2,.5],180] call BIS_fnc_spawnGroup;
		(group (leader _survivors)) setVariable ["f_cacheExcl", true];
        _survivors setBehaviour "COMBAT";
        _survivors setSpeedMode "NORMAL";
		
        _survivorspos = getposWorld leader _survivors;
		_myUnitCount = count units _survivors;
		
		// create tasks
		_taskString1 = format ["Use a boat to search for %1 shipwrecked civilians near their last known location.<br/><br/>Use Helicopters for aerial recon and slingloading boats to distant locations.", _myUnitCount];
		_taskDesc1 = "SAR Civilians (Sea)";
		_taskString2 = format ["Return the %1 survivors to shore at your harbor.", _myUnitCount];
		_taskDesc2 = "Recover civilians (Sea)";
			
			
		[independent,["task1"],[_taskString1, _taskDesc1, "marker"],_centerPos,1,1,true,"search",false] call BIS_fnc_taskCreate;
		[independent,["task2"],[_taskString2, _taskDesc2, "marker"],"aaf_harbor",0,2,true,"walk",false] call BIS_fnc_taskCreate;
		
		
		// create AO Marker
		 [1000,1000,"ColorCIV",_centerPos,"ELLIPSE"] spawn SM_fn_createMarker;
	
		// set missionsstatus
        _MissionStatus = 1;
      };

      // missionstatus 1
      if ( _MissionStatus == 1 ) then {
        // mission is during night shoot flare when players are close by
        _tod = daytime;
		_nearcamp = _boatPos nearEntities 100;
        // check if day or night
        if (_tod > 6 && _tod < 18) then {
            // daytime, move on
			if (vehicle player in _nearCamp) then {
					_flrObj1 = createVehicle ["SmokeshellRed", _survivorspos, [], 0, "NONE"];
					//_flrObj2 = "F_20mm_Red" createvehicle (_survivorspos ModelToWorld [random 20,random 10,120]); _flrObj2 setVelocity 
                    _MissionStatus = 2;
            	};
        }
        else {
			// if players nearby, launch flares
            if (vehicle player in _nearCamp) then {
					flrObj1 = "F_20mm_red" createvehicle ((player) ModelToWorld [10,10,150]); flrObj1 setVelocity [0,0,-5];
					sleep 2;
					flrObj2 = "F_20mm_red" createvehicle ((player) ModelToWorld [1,1,150]); flrObj2 setVelocity [0,0,-5];				


                    _MissionStatus = 2;
            	};
          };
        };

        // missionstatus 2
        if ( _MissionStatus == 2 ) then {
        _nearcamp2 = _survivorspos nearEntities 30;
			if ((vehicle player in _nearcamp2) && ((vehicle player) isKindOf "SHIP")) then {
            { _x assignAsCargo vehicle player;
			  _x allowDamage false;
              } forEach units _survivors;
            (units _survivors) orderGetIn true;
			_survivors setBehaviour "Careless";
			_survivors setSpeedMode "Full";
			
			waitUntil {{_x in (vehicle player)} count units _survivors == count units _survivors};
            
			_MissionStatus = 3;
          };
        };

        // missionstatus 3
        if ( _MissionStatus == 3 )  then {
          if ( {_x in (vehicle player) } forEach units _survivors) then {
             // create dropoff trigger
            _trg_dropoff = createTrigger ["EmptyDetector", (getMarkerPos "aaf_harbor")];
            _trg_dropoff setTriggerArea [100, 100, 0, false];
            _trg_dropoff triggerAttachVehicle [vehicle (units _survivors select 0)];
            _trg_dropoff setTriggerActivation ["MEMBER", "PRESENT", true];
            _trg_dropoff setTriggerTimeout [3, 3, 0, false];
            _trg_dropoff setTriggerStatements [
            "isServer && ((vehicle player) in thisList) && (vehicle player) isKindOf 'SHIP'",
            "this",
            ""
            ];
			nul = [] spawn SM_fn_delMarker;
            ['task1','Succeeded'] call BIS_fnc_taskSetState;
            sleep 3;
            ['task2','Assigned'] call BIS_fnc_taskSetState;
            _MissionStatus = 4;
          };
        };

        // missionstatus 4
        if ( _MissionStatus == 4 ) then {
          // dismount survivors move to aaf gather land
          if (triggeractivated _trg_dropoff) then {
            { unassignVehicle _x } forEach units _survivors;
            _survivors leaveVehicle (vehicle player);
            wpsafe = _survivors addWaypoint [(getmarkerpos 'aaf_gather_sea'), 0];
            wpsafe setWaypointStatements ["true", "FinishedMoving = true;"];
            wpsafe setWaypointType 'MOVE';
            wpsafe setWaypointBehaviour "SAFE";
            wpsafe setWaypointSpeed "FULL";
            wpsafe setWaypointCompletionRadius 10;
          };
          if ( FinishedMoving ) then {
              _MissionStatus = 5;
          };
        };



        // missionstatus 5
        if ( _MissionStatus == 5 ) exitWith {
          if (({alive _x} count units _survivors) > 0) then {
          FinishedMoving = nil;
          ['task2','Succeeded'] call BIS_fnc_taskSetState;
         
          {deleteVehicle _x} forEach units _survivors;
          deleteGroup _survivors;
          deleteVehicle _source01;
		  deleteVehicle _veh;
          deleteVehicle _veh2;
          sleep 5;
          ["task2",true] call BIS_fnc_deleteTask;
          ["task1",true] call BIS_fnc_deleteTask;
          if (isserver) then { null=[]execVM "sidefinder.sqf"; };
          _ssarMission = false;
          };
        };
		
		if ((( _MissionStatus > 2 ) || ( _MissionStatus < 5 )) && (({alive _x} count units _survivors) == 0)) then {
		["task1", "FAILED",true] spawn BIS_fnc_taskSetState;
		["task2", "FAILED",true] spawn BIS_fnc_taskSetState;
		_MissionStatus = 5;
		};
		
        // end while loop
        sleep 1;
        //systemChat format ["Missionstatus: %1", _MissionStatus]; // uncomment for debug
    };
if(true)exitWith{};
