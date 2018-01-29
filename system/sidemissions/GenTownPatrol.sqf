if (!isServer) exitWith {};
  // set false the side1 so side finder will not execute this mission again
  side1 = false;
  sleep 60;


// private variables for this script
private ["_vehAmbushArray","_markerAmbushArray", "_woundedArray", "_centerPos", "_veh", "_source01", "_woundedGroup", "_extraction_point", "_overwatchPos", "_IEDGrp","_ambushGrp","_trg_sad","_trg_pickup","_trg_dropoff","_mrk_sad"]; // uncomment _trg if trigger used
_patrolArray = ["1","2","3","4","5"];
_faceArray = ["GreekHead_A3_02","GreekHead_A3_03","GreekHead_A3_01"];

// test
_markerArray2 = ["townsweep2_1","townsweep2_2","townsweep2_3"];


_patrolSelect = (_patrolArray call BIS_fnc_selectRandom);

switch (_patrolSelect) do {
  case (1): {
      //code
      _markerArray = ["townsweep1_1","townsweep1_2","townsweep1_3"];
  };
  case (2): {
      //code
      _markerArray2 = ["townsweep2_1","townsweep2_2","townsweep2_3"];
  };
  case (3): {
      //code
      _markerArray = ["townsweep3_1","townsweep3_2","townsweep3_3"];
  };
  case (4): {
      //code
      _markerArray = ["townsweep4_1","townsweep4_2","townsweep4_3"];
  };
  case (5): {
      //code
      _markerArray = ["townsweep2_3","townsweep4_1","townsweep4_2"];
  };    //cases (insertable by snippet)
};



//_policeMan = "C_man_1" createUnit [getMarkerPos "townsweep2_1", police,,0.6, "corporal"];

//spawnPolice = "C_man_1" createUnit [ _centerPos, hvtGroup, "hvt = this; this allowFleeing 0; this removeWeapon (primaryWeapon this); this setBehaviour 'Aware';",0.6, "corporal"];

_pos = getMarkerPos "twnswp2_1";
hint format ["LOc: %1",_pos ];

_vehPolice = createVehicle["C_Offroad_01_F", _pos, [], 0, "CAN_COLLIDE"];

/*
_vehPolice = createVehicle ["C_Offroad_01_F",getMarkerPos "townsweep2_1",[],0,"can_collide"];
sleep 1;
*/
[
	_vehPolice,
	["blue",1],
	["hidePolice",0,"HideServices",0,"BeaconsStart",1,"HideBumper2",0,"Proxy",0,"Destruct",0]
] call BIS_fnc_initVehicle;


comment "Related vehicle classes:";
comment "C_Offroad_01_F";
comment "B_G_Offroad_01_F";


// create police group
police = createGroup civilian;
sleep 1;
police setBehaviour "SAFE";

// Create random policeman
_policeMan = "C_man_1" createUnit [getMarkerPos "twnswp2_1",police,"this setVariable [""BIS_enableRandomization"", false]; p1 = this;",0.5];
police setBehaviour "SAFE";
question = p1 addaction ["Consult local police", {0 = cursorTarget spawn interrogate}, cursortarget, 6, true, false, "", "cursorTarget isKindOf 'MAN' && player distance cursorTarget < 3"];
// askPolice = _policeMan addAction["Interrogate", { 0 = cursorTarget spawn interrogate}, nil, 1.5, false, true, "", "cursorTarget isKindOf 'MAN' && player distance cursorTarget < 3"];

police setBehaviour "SAFE";

// hostage = hvt addaction ["Take Hostage", { _holder = createVehicle ["GroundWeaponHolder", position cursortarget, [], 0, "CAN_COLLIDE"]; _holder addWeaponCargoGlobal [currentWeapon cursorTarget, 1]; cursorTarget removeWeaponGlobal (currentWeapon cursorTarget); cursortarget action ["Surrender", cursortarget]; cursorTarget setCaptive true; cursorTarget removeAction hostage;}, cursortarget, 6, true, false, "", "cursorTarget isKindOf 'MAN' && player distance hvt < 3"];

directionText = {
    if ((_this > 22.5) && (_this <= 67.5)) exitWith {"NORTHEAST"};
    if ((_this > 67.5) && (_this <= 112.5)) exitWith {"EAST"};
    if ((_this > 112.5) && (_this <= 157.5)) exitWith {"SOUTHEAST"};
    if ((_this > 157.5) && (_this <= 202.5)) exitWith {"SOUTH"};
    if ((_this > 202.5) && (_this <= 247.5)) exitWith {"SOUTHWEST"};
    if ((_this > 247.5) && (_this <= 295.5)) exitWith {"WEST"};
    if ((_this > 295.5) && (_this <= 337.5)) exitWith {"NORTHWEST"};
    "NORTH"
};

interrogate = {
    if (random 100 > 5) exitWith {systemChat "Everything is fine here!"};

    private "_enemy";
    _enemy = { if (side _x == west || side _x == east) exitWith {_x}; objNull } forEach (_this nearEntities [["Man", "Air", "Car", "Motorcycle", "Tank"],1000] - [player]);
    if (isNull _enemy) exitWith {systemChat "I've seen no baddies recently"};

    systemChat format["There is a %1 group of enemies to the %2 of here",
        call {
            private "_n";
            _n = count units group _enemy;
            switch true do {
                case (_n > 8): {"massive"};
                case (_n > 5): {"large"};
                case (_n > 0): {"small"};
                default "";
            }
        },
        ([_this,_enemy] call BIS_fnc_dirTo) call directionText
    ];
};

{
  comment "Remove existing items";
  removeAllWeapons _x;
  removeAllItems _x;
  removeAllAssignedItems _x;
  removeUniform _x;
  removeVest _x;
  removeBackpack _x;
  removeHeadgear _x;
  removeGoggles _x;

  comment "Add containers";


  _x forceAddUniform "U_Marshal";
  for "_i" from 1 to 2 do {_x addItemToUniform "FirstAidKit";};
  _x addVest "V_TacVest_blk_POLICE";
  for "_i" from 1 to 2 do {_x addItemToVest "FirstAidKit";};
  for "_i" from 1 to 2 do {_x addItemToVest "SmokeShell";};
  for "_i" from 1 to 6 do {_x addItemToVest "6Rnd_45ACP_Cylinder";};
  _x addHeadgear "H_Cap_police";
  comment "Add weapons";
  _x addWeapon "hgun_Pistol_heavy_02_F";
  _x setFace (_faceArray call BIS_fnc_selectRandom);
  _x action ["SwitchWeapon", _x, _x, -1];
} foreach units police;


action_interrogate = player addAction["Interrogate", {
    0 = cursorTarget spawn interrogate
}, nil, 1.5, false, true, "", "
    (alive cursorTarget && side cursorTarget == civilian && {player distance cursorTarget < 3})
"];


if (isserver) then { null=[]execVM "sidefinder.sqf"; };

if(true)exitWith{};
