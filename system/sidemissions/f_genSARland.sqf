if (!isServer) exitWith {};
side2 = false; // set false the side1 so sidefinder will not execute this mission again

private ["_civArray","_vehArray","_campstuffArray","_markerArray", "_centerPos", "_campPos", "_lsarMission", "_MissionStatus","_veh", "_campfire", "_stuff","_stuff2","_debris","_dropoff","_survivors","_w1","_w2","_tod","_night","_nearCamp","_nearCamp2","_trg_dropoff"]; // uncomment _trg if trigger used

_civArray = ["C_man_polo_1_F_afro","C_man_polo_2_F_euro","C_man_polo_1_F_asia","C_man_polo_4_F_euro","C_man_p_fugitive_F_euro","C_man_hunter_1_F","C_man_polo_5_F_euro"," C_man_polo_2_F_afro"];
_vehSarArray = ["Land_TentA_F","Land_TentDome_F"];
_campstuffArray = ["Land_CampingChair_V1_folded_F","Land_WoodPile_F","Land_Sleeping_bag_blue_F","Land_Sleeping_bag_folded_F","Land_WoodenLog_F","Land_LuggageHeap_02_F"];
_markerArray = ["aaf_lsar1","aaf_lsar1_1","aaf_lsar1_2","aaf_lsar1_3","aaf_lsar1_4","aaf_lsar1_5","aaf_lsar1_6","aaf_lsar1_7","aaf_lsar1_8","aaf_lsar1_9","aaf_lsar1_10"];


// define main locations
_centerPos = getMarkerPos (_markerArray call BIS_fnc_selectRandom);
_campPos = [_centerPos, 30 + (random 100), random 360] call BIS_fnc_relPos;


// define variables for main loop
_lsarMission = true;
FinishedMoving = false;
_MissionStatus = 0;

// main loop
while {_lsarMission} do {
    // missionstatus 0
		if ( _MissionStatus == 0 ) then {
		
		// create camp
        _veh = createVehicle [(_vehSarArray call BIS_fnc_selectRandom), _campPos, [], 1, "NONE"];
        _stuff = createVehicle [(_campstuffArray call BIS_fnc_selectRandom), _campPos, [], 1, "NONE"];
        _stuff2 = createVehicle [(_campstuffArray call BIS_fnc_selectRandom), _campPos, [], 1, "NONE"];
        _debris = createVehicle ["Land_Garbage_square5_F", _campPos, [], 1, "NONE"];
         // reposition
        _stuff setPos [(getPos _veh select 0) +3, (getPos _veh select 1) +2];
        _stuff2 setPos [(getPos _veh select 0) +5, (getPos _veh select 1) +3];

        // create civilians nearby
        _survivors = createGroup civilian;
		          sleep 0.1;
        _w1 = _survivors createUnit [(_civArray call BIS_fnc_selectRandom), getPosATL _veh, [], 10, "NONE"];
		          sleep 0.1;
        _w2 = _survivors createUnit [(_civArray call BIS_fnc_selectRandom), getPosATL _veh, [], 15, "NONE"];
        [_w1,_w2] join _survivors;
        (group (leader _survivors)) setVariable ["f_cacheExcl", true];
		
		// make survivors unconcious and give player the ability to "revive"
        {
		_x setDamage 0.5;
		_x setUnconscious true;
		[ _x,"heal","\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa","\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa","_this distance _target < 2","true",{hint "Started!"},{_target setDammage (getDammage _target - 0.1)},{_target setUnconscious false},{hint "Afraid of death?"},[],10,nil,true,false] call BIS_fnc_holdActionAdd;
		sleep 0.1;
		} forEach units _survivors;
		


        
		
		// create tasks
		_taskString1 = "Use a car or truck to search for the missing civilians near their last known location.<br/><br/>Hint: Use Helicopters for aerial recon.";
		_taskDesc1 = "SAR Civilians (Land)";

		_taskString2 = "Return the civilians to your base.";
		_taskDesc2 = "Recover civilians (Land)";

		[independent,["task1"],[_taskString1, _taskDesc1, "marker"],_centerPos,1,1,true,"search",false] call BIS_fnc_taskCreate;
		[independent,["task2"],[_taskString2, _taskDesc2, "marker"],"aaf_hq",0,2,true,"walk",false] call BIS_fnc_taskCreate;

            // create dropoff trigger
            _trg_dropoff = createTrigger ["EmptyDetector", (getMarkerPos "aaf_hq")];
            _trg_dropoff setTriggerArea [250, 250, 0, false];
            _trg_dropoff triggerAttachVehicle [vehicle (units _survivors select 0)];
            _trg_dropoff setTriggerActivation ["MEMBER", "PRESENT", true];
            _trg_dropoff setTriggerTimeout [3, 3, 0, false];
            _trg_dropoff setTriggerStatements [
            "isServer && ((vehicle player) in thisList) && (vehicle player) isKindOf 'Car'",
            "",
            ""
            ];		
		
		// create AO Marker
		//nul = [250,250,"ColorCIV",_centerPos,"ELLIPSE"] spawn SM_fn_createMarker; // create marker for last known position
		nul = [20,20,"ColorCIV",_camppos,"ELLIPSE"] spawn SM_fn_createMarker; // create marker for last known position
		_MissionStatus = 1;
      };

      // missionstatus 1
      if ( _MissionStatus == 1 ) then {
        // mission is during night shoot flare when players are close by
        _tod = daytime;

        // check if day or night
        if (_tod > 6 && _tod < 18) then {
            // daytime, move on
            _campfire = createVehicle ["Land_Campfire_F", _campPos, [], 0, "NONE"];
            _campfire setPos [(getPos _veh select 0) +5, (getPos _veh select 1) +0];
            _campfire setVectorUp(surfaceNormal(getPos _campfire));
            _MissionStatus = 2;
        }
        else {
            _nearCamp = _campPos nearEntities 50;
            _campfire = createVehicle ["Campfire_burning_F", _campPos, [], 0, "NONE"];
            _campfire setPos [(getPos _veh select 0) +5, (getPos _veh select 1) +0];
            _campfire setVectorUp(surfaceNormal(getPos _campfire));
            // if players nearby, launch flares
            if (vehicle player in _nearCamp) then {
					flrObj1 = "F_20mm_red" createvehicle ((player) ModelToWorld [10,10,150]); flrObj1 setVelocity [0,0,-5];
					sleep 2;
					flrObj2 = "F_20mm_red" createvehicle ((player) ModelToWorld [1,1,150]); flrObj2 setVelocity [0,0,-5];				
            	};
            _MissionStatus = 2;
          };
        };

        // missionstatus 2
        if ( _MissionStatus == 2 ) then {
          // continue mission once all survivors are healed
			waitUntil {{lifeState _x == "HEALTHY"} count units _survivors == count units _survivors};
			{_x setUnconscious false;
			} forEach units _survivors;
			_MissionStatus = 3;
        };

        // missionstatus 3
        if ( _MissionStatus == 3 )  then {
//          [_w1,_w2] join _survivors;
          //_nearcamp2 = _campPos nearEntities 50;
          _nearcamp2 = _campPos nearEntities [["Car"], 50];
          //systemChat format ["Nearcamp2: %1", _nearcamp2]; // uncomment for debug
          if ((vehicle player in _nearcamp2) && ((vehicle player) isKindOf "CAR")) then {
            { _x assignAsCargo vehicle player;} forEach units _survivors;
            (units _survivors) orderGetIn true;
			_survivors setBehaviour "Careless";
			_survivors setSpeedMode "Full";
			
			waitUntil {{_x in (vehicle player)} count units _survivors == count units _survivors};
            
			_MissionStatus = 4;
          };
        };

        // missionstatus 4
        if ( _MissionStatus == 4 )  then {
          if ( {_x in (vehicle player) } forEach units _survivors) then {

            ['task1','Succeeded'] call BIS_fnc_taskSetState;
			nul = [] spawn SM_fn_delMarker;
            sleep 3;
            ['task2','Assigned'] call BIS_fnc_taskSetState;
            _MissionStatus = 5;
          };
        };

        // missionstatus 5
        if ( _MissionStatus == 5 ) then {
          // dismount survivors move to aaf gather land
          if (triggeractivated _trg_dropoff) then {
            { unassignVehicle _x } forEach units _survivors;
            _survivors leaveVehicle (vehicle player);
            wpsafe = _survivors addWaypoint [(getmarkerpos 'aaf_gather_land'), 1];
            wpsafe setWaypointStatements ["true", "FinishedMoving = true;"];
            wpsafe setWaypointType 'MOVE';
            wpsafe setWaypointBehaviour "CARELESS";
            wpsafe setWaypointSpeed "FULL";
            wpsafe setWaypointCompletionRadius 10;
          };
          if ( FinishedMoving ) then {
              _MissionStatus = 6;
          };
        };

        // missionstatus 6
        if ( _MissionStatus == 6 ) exitWith {
		if (({alive _x} count units _survivors) > 0) then {
          FinishedMoving = nil;
		  {deleteVehicle _x} forEach units _survivors;
          deletegroup _survivors;
          ['task2','Succeeded'] call BIS_fnc_taskSetState;
		  };
		  deleteVehicle _campfire;
          deleteVehicle _stuff;
          deleteVehicle _stuff2;
          deleteVehicle _veh;
		  deleteVehicle _debris;
		  deleteVehicle _trg_dropoff;
		  

          sleep 5;
          ["task1",true] call BIS_fnc_deleteTask;
		  ["task2",true] call BIS_fnc_deleteTask;		  
          sleep 0.1;
		  if (isserver) then { null=[]execVM "sidefinder.sqf"; };
		  _lsarMission = false;		  
        };
		
		if ((( _MissionStatus > 2 ) || ( _MissionStatus < 6 )) && (({alive _x} count units _survivors) == 0)) then {
		["task1", "FAILED",true] spawn BIS_fnc_taskSetState;
		["task2", "FAILED",true] spawn BIS_fnc_taskSetState;
		nul = [] spawn SM_fn_delMarker;
		_MissionStatus = 6;
		};
        // end while loop
        sleep 1;
        //systemChat format ["Missionstatus: %1", _MissionStatus]; // uncomment for debug
    };
if(true)exitWith{};
