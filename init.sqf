if ((!isServer) && (player != player)) then {waitUntil {player == player};}; // Player sync

// Initialise TFAR
// compile preprocessFileLineNumbers "\task_force_radio\functions\common.sqf";

// --------------------------------------------------------------------------------------------------------------
/*
// TFAR Settings
//#include "\task_force_radio\functions\common.sqf";
//compile preprocessFileLineNumbers "\task_force_radio\functions\common.sqf";

//Serious mode
tf_radio_channel_name = "TaskForceRadio";
tf_radio_channel_password = "123";

// general settings
tf_no_auto_long_range_radio = true;
tf_give_personal_radio_to_regular_soldier = false;
tf_same_sw_frequencies_for_side = true;
tf_same_lr_frequencies_for_side = true;
tf_give_microdagr_to_soldier = true;
tf_speakerDistance = 30;
Tf_terrain_interception_coefficient = 6.0;

//Standardradios
BLU_F_personal_tf_faction_radio = "tf_anprc148jem";
BLU_F_rifleman_tf_faction_radio = "tf_anprc154";
BLU_G_F_personal_tf_faction_radio = "tf_anprc148jem";
BLU_G_F_rifleman_tf_faction_radio = "tf_anprc154";
OPF_F_personal_tf_faction_radio = "tf_fadak";
OPF_F_rifleman_tf_faction_radio = "tf_pnr1000a";

//Frequencies
//Blufor
tf_freq_west = [0,7,["101","102","103","104","105","106","107","108","109","110","111","112","113"],0,"_bluefor",-1,0];
tf_freq_west_lr = [0,7,["20","21","22","23","24","25","26","27","27.5","28","28.5","29","29.5"],0,"_bluefor",-1,0];

//Opfor
tf_freq_east = [0,7,["221","222","223","224","225","226","227","228","229","230","231","232","233"],0,"_opfor",-1,0];
tf_freq_east_lr = [0,7,["30","31","32","33","34","35","36","37","37.5","38","38.5","39","39.5"],0,"_opfor",-1,0];

//Indfor
tf_freq_guer = [0,7,["341","342","343","344","345","346","347","348","349","350","351","352","353"],0,"_indep",-1,0];
tf_freq_guer_lr = [0,7,["40","41","42","43","44","45","46","47","47.5","48","48.5","49","49.5"],0,"_indep",-1,0];

//Set public variables for all clients
if (isServer) then {
publicVariable "tf_no_auto_long_range_radio";
publicVariable "tf_give_personal_radio_to_regular_soldier";
publicVariable "TF_give_microdagr_to_soldier";
publicVariable "tf_same_sw_frequencies_for_side";
publicVariable "tf_same_lr_frequencies_for_side";
publicVariable "tf_terrain_interception_coefficient";
publicVariable "tf_speakerDistance";
publicVariable "BLU_F_personal_tf_faction_radio";
publicVariable "BLU_F_rifleman_tf_faction_radio";
publicVariable "BLU_G_F_personal_tf_faction_radio";
publicVariable "BLU_G_F_rifleman_tf_faction_radio";
publicVariable "OPF_F_personal_tf_faction_radio";
publicVariable "OPF_F_rifleman_tf_faction_radio";
publicVariable "tf_freq_west";
publicVariable "tf_freq_west_lr";
publicVariable "tf_freq_east";
publicVariable "tf_freq_east_lr";
publicVariable "tf_freq_guer";
publicVariable "tf_freq_guer_lr";
publicVariable "tf_freq_name";
};

*/
// --------------------------------------------------------------------------------------------------------------

// ppeffect
//
//"colorCorrections" ppEffectAdjust [1.01, 1.18, -0.04, [1.0, 1.4, 0.8, -0.04], [0.55, 0.55, 0.72, 1.35],  [0.699, 1.787, 0.314, 20.03]];
"colorCorrections" ppEffectAdjust [1.18, 1.15, -0.06, [0.9, 1.1, 0.8, -0.05], [0.55, 0.55, 0.72, 1.25],  [0.699, 1.787, 0.314, 20.03]];
"colorCorrections" ppEffectCommit 1;
"colorCorrections" ppEffectEnable true;


null = [] execVM "scripts\real_weather.sqf";


// DO NOT CHANGE ANYTHING FROM HERE ON
// SKILL Settings
//by psycho
["%1 --- Executing TcB AIS init.sqf",diag_ticktime] call BIS_fnc_logFormat;
// TcB AIS Wounding System --------------------------------------------------------------------------
if (!isDedicated) then {
	TCB_AIS_PATH = "ais_injury\";
	[] spawn {
		{[_x] call compile preprocessFile (TCB_AIS_PATH+"init_ais.sqf")} forEach (if (isMultiplayer) then {playableUnits} else {switchableUnits});		// execute for every playable unit

	//{[_x] call compile preprocessFile (TCB_AIS_PATH+"init_ais.sqf")} forEach (units group player);													// only own group - you cant help strange group members

	//{[_x] call compile preprocessFile (TCB_AIS_PATH+"init_ais.sqf")} forEach [p1,p2,p3,p4,p5];														// only some defined units
};

};
sleep 5;
// ====================================================================================

// F3 SETTINGS

// ====================================================================================

// F3 - Disable Saving and Auto Saving
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

enableSaving [false,false];
enableTeamswitch false;			// TcB AIS wont support teamswitch

// ====================================================================================

// F3 - Mute Orders and Reports
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

enableSentences false;
0 fadeRadio 0;

// ====================================================================================

// F3 - MapClick Teleport
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

// f_var_mapClickTeleport_Uses = 0;					// How often the teleport action can be used. 0 = infinite usage.
// f_var_mapClickTeleport_TimeLimit = 0; 			// If higher than 0 the action will be removed after the given time.
// f_var_mapClickTeleport_GroupTeleport = false; 	// False: everyone can teleport. True: Only group leaders can teleport and will move their entire group.
// f_var_mapClickTeleport_Units = [];				// Restrict map click teleport to these units
// f_var_mapClickTeleport_Height = 0;				// If > 0 map click teleport will act as a HALO drop and automatically assign parachutes to units
// [] execVM "f\mapClickTeleport\f_mapClickTeleportAction.sqf";

// ====================================================================================

// F3 - Briefing
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

f_script_briefing = [] execVM "briefing.sqf";

// ====================================================================================

// F3 - F3 Folk ARPS Group IDs
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

f_script_setGroupIDs = [] execVM "f\setGroupID\f_setGroupIDs.sqf";

// ====================================================================================

// F3 - Buddy Team Colours
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

f_script_setTeamColours = [] execVM "f\setTeamColours\f_setTeamColours.sqf";

// ====================================================================================

// F3 - Fireteam Member Markers
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

[] spawn f_fnc_SetLocalFTMemberMarkers;

// ====================================================================================

// F3 - F3 Folk ARPS Group Markers
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

f_script_setGroupMarkers = [] execVM "f\groupMarkers\f_setLocalGroupMarkers.sqf";

// ====================================================================================

// F3 - F3 Common Local Variables
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// WARNING: DO NOT DISABLE THIS COMPONENT
if(isServer) then {
	f_script_setLocalVars = [] execVM "f\common\f_setLocalVars.sqf";
};

// ====================================================================================

// F3 - Automatic Body Removal
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

f_removeBodyDelay = 180;
f_removeBodyDistance = 1000;
f_doNotRemoveBodies = [];
[] execVM "f\removeBody\f_addRemoveBodyEH.sqf";


// ====================================================================================

// F3 - Dynamic View Distance
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

 f_var_viewDistance_default = 1250;
 f_var_viewDistance_tank = 2000;
 f_var_viewDistance_car = 2000;
 f_var_viewDistance_rotaryWing = 3500;
 f_var_viewDistance_fixedWing = 3500;
 f_var_viewDistance_crewOnly = true;
 [] execVM "f\dynamicViewDistance\f_setViewDistanceLoop.sqf";

// ====================================================================================

// F3 - Authorised Crew Check
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

/*
VehicleName addEventhandler ["GetIn", {[_this,[UnitName1,UnitName2],false] call f_fnc_authorisedCrewCheck}];
VehicleName addEventhandler ["GetIn", {[_this,["UnitClass1","UnitClass2"],false] call f_fnc_authorisedCrewCheck}];
*/

// ====================================================================================

// F3 - Casualties Cap
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

// [[GroupName or SIDE],100,1] execVM "f\casualtiesCap\f_CasualtiesCapCheck.sqf";
// [[GroupName or SIDE],100,{code}] execVM "f\casualtiesCap\f_CasualtiesCapCheck.sqf";

// BLUFOR > NATO
// [BLUFOR,100,1] execVM "f\casualtiesCap\f_CasualtiesCapCheck.sqf";

// OPFOR > CSAT
// [OPFOR,100,1] execVM "f\casualtiesCap\f_CasualtiesCapCheck.sqf";

// INDEPENDENT > AAF
// [INDEPENDENT,100,1] execVM "f\casualtiesCap\f_CasualtiesCapCheck.sqf";

// ====================================================================================

// F3 - AI Skill Selector
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

// f_var_civAI = independent; 		// Optional: The civilian AI will use this side's settings
// [] execVM "f\setAISKill\f_setAISkill.sqf";

// ====================================================================================

// F3 - Assign Gear AI
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

// [] execVM "f\assignGear\f_assignGear_AI.sqf";

// ====================================================================================

// F3 - Name Tags
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

//  [] execVM "f\nametag\f_nametags.sqf";

// ====================================================================================

// F3 - Group E&E Check
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

// [side,ObjectName or "MarkerName",100,1] execVM "f\EandEcheck\f_EandECheckLoop.sqf";
// [["Grp1","Grp2"],ObjectName or "MarkerName",100,1] execVM "f\EandEcheck\f_EandECheckLoop.sqf";

// ====================================================================================

// F3 - ORBAT Notes
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

// [] execVM "f\briefing\f_orbatNotes.sqf";

// ====================================================================================

// F3 - Loadout Notes
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

 [] execVM "f\briefing\f_loadoutNotes.sqf";

// ====================================================================================

// F3 - Join Group Action
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

// [false] execVM "f\groupJoin\f_groupJoinAction.sqf";

// ====================================================================================

// F3 - Mission Timer/Safe Start
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

[] execVM "f\safeStart\f_safeStart.sqf";

// ====================================================================================

// F3 - JIP setup
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

f_var_JIP_FirstMenu = false;		// Do players connecting for the first time get the JIP menu? - This only works in missions with respawn.
f_var_JIP_RemoveCorpse = true;		// Remove the old corpse of respawning players?
f_var_JIP_GearMenu = false;			// Can JIP/respawned players select their own gear? False will use gear assigned by F3 Gear Component if possible

// ====================================================================================

// F3 - AI Unit Caching
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

[120] spawn f_fnc_cInit;

// Note: Caching aggressiveness is set using the f_var_cachingAggressiveness variable; possible values:
// 1 - cache only non-leaders and non-drivers
// 2 - cache all non-moving units, always exclude vehicle drivers
// 3 - cache all units, incl. group leaders and vehicle drivers
f_var_cachingAggressiveness = 1;

// ====================================================================================

 // F3 - Radio Systems Support
 // Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

 [] execVM "f\radios\radio_init.sqf";

// ====================================================================================

// F3 - Medical Systems Support
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

// SWS Config Settings
// How many extra FirstAidKits (FAKS) each player should receive when using the F3 Simple Wounding System:
// f_wound_extraFAK = 2;
// f_wound_briefing = true; // no briefing screen for medical system
// [] execVM "f\medical\medical_init.sqf";

// ====================================================================================
