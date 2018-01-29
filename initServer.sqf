if (!isServer) exitWith {};

// SKILL Settings
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

// weather
null = [] execVM "scripts\real_weather.sqf";

// use this code to control side missions call, later remove called mission from missions list
if (isNil "side1") then { side1 = true;};
if (isNil "side2") then { side2 = true;};
if (isNil "side3") then { side3 = true;};
if (isNil "side4") then { side4 = true;};
if (isNil "side5") then { side5 = true;};

[] execVM "system\sidefinder.sqf";

sleep 1;
