SM_fn_delMarker = {
    deleteMarker "mrkAO";
    for "_i" from 0 to 3 do
      {
        deleteMarker format["mrkAO%1",_i];
      };
  };





SM_fn_setskill = {
private ["_group"];
_group = _this select 0;
  {
  	_x setSkill ["aimingspeed", 0.5];
  	_x setSkill ["aimingaccuracy", 0.25];
  	_x setSkill ["aimingshake", 0.25];
  	_x setSkill ["reloadSpeed", 0.5];

  	_x setSkill ["spotdistance", 0.45];
  	_x setSkill ["spottime", 0.45];
  	_x setSkill ["spotdistance", 0.45];

  	_x setSkill ["endurance", 0.75];
  	_x setSkill ["commanding", 0.75];
  	_x setSkill ["courage", 0.75];
  } forEach allUnits;
};
