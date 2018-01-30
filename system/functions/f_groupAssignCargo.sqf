params ["_vehParam","_groupParam"];

private ["_entryTime"];

{ _x assignAsCargo (_vehParam select 0)} forEach units _groupParam;
_groupParam setSpeedMode "Fast";
(units _groupParam) orderGetIn true;

// if units don't enter in a timely fashion, make 'em.

_entryTime = time + 60;
waitUntil {time >= _entryTime};
if  ( {_x in _vehParam} count (units _groupParam) != ({alive _x} count units _groupParam) ) then {
//_entryIndex =  fullCrew [_vehParam, "cargo", true];
  {
    if !(_x in _vehparam) then {
      _x moveInCargo (_vehParam select 0);
    };
  } forEach units _groupParam;
};
true
// EOF
