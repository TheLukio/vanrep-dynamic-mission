private ["_dir","_vehArray","_vehFlyby"];
_dir = random 4;
_vehArray = ["I_Heli_Light_03_unarmed_F","I_Heli_Transport_02_F","I_Plane_Fighter_03_AA_F","I_Plane_Fighter_04_F"];
_vehFlyby = _vehArray call BIS_fnc_selectRandom;
//_intervals = random [3, 7, 11];


switch (_dir) do {
    //cases (insertable by snippet)
    case (1): {
      ambientFly = [getMarkerPos "amb_flyby_2", getMarkerPos "amb_flyby_1", 350, "NORMAL", _vehFlyby, independent] call BIS_fnc_ambientFlyBy;
    };
    case (2): {
      ambientFly = [getMarkerPos "amb_flyby_1", getMarkerPos "amb_flyby_2", 350, "NORMAL", _vehFlyby, independent] call BIS_fnc_ambientFlyBy;
    };
    case (3): {
      ambientFly = [getMarkerPos "amb_flyby_3", getMarkerPos "amb_flyby_4", 350, "NORMAL", _vehFlyby, independent] call BIS_fnc_ambientFlyBy;
    };
    case (4): {
      ambientFly = [getMarkerPos "amb_flyby_4", getMarkerPos "amb_flyby_3", 350, "NORMAL", _vehFlyby, independent] call BIS_fnc_ambientFlyBy;
    };
    default {
      ambientFly = [getMarkerPos "amb_flyby_1", getMarkerPos "amb_flyby_3", 200, "NORMAL", _vehFlyby, independent] call BIS_fnc_ambientFlyBy;
    };
};
