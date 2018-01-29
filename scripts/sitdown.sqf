//============================ 'sitdown.sqf'

/*
 Script Made By  MacRae    
 Modded by [KH]Jman
 Tweaked by Quiksilver for the addAction shit and MP compatibility
*/
private ["_chair","_unit"];
_chair = _this select 0; 
_unit = _this select 1; 

_chair setVectorUp [0,0,1];
[[_unit,"Crew"],"switchMove",TRUE,FALSE] spawn BIS_fnc_MP;
player setVariable ['QS_seated',true];
_unit setPos (getPos _chair); 
_unit setDir ((getDir _chair) - 180);
[[_unit,"Crew"],"switchMove",TRUE,FALSE] spawn BIS_fnc_MP;		// again!
standup = _unit addaction [
	"Stand Up",
	"scripts\standup.sqf",
	[],
	10,
	true,
	true,
	"",
	"(player getVariable 'QS_seated')"
];
_unit setPos [getPos _unit select 0, getPos _unit select 1,((getPos _unit select 2) +1)];

