//============================ 'standup.sqf'

/*
 Script Made By  MacRae    
 Modded by [KH]Jman
 Tweaked by Quiksilver for MP compatibility
*/

player setVariable ['QS_seated',false];
[[player,""],"switchMove",TRUE,FALSE] spawn BIS_fnc_MP;
player removeAction standup;

//============================ On the chair in editor init field
/*

this addAction ["Sit Down","sitdown.sqf",[],10,true,true,'',"(!(player getVariable 'QS_seated')) && (abs(speed player) < 1)"];

*/