if (!isServer) exitWith {};

// set false the side1 so side finder will not execute this mission again
side5 = false;
sleep 60;
s
// private variables for this script
private ["_hvtArray","_markerArray", "_centerPos", "_areapos", "_randomPatrolType", "_mrk_pickup", "_mrk_hvt", "_mrk_base", "_trg_hvt_check", "_trg_Cap_hvt", "_trg_hvt_safe","_trg_hvt_done","_hvtMission","_hvtCapture"]; // uncomment _trg if trigger used,

// define used arrays
_hvtArray = ["B_G_officer_F", "I_G_resistanceCommander_F","O_officer_F","B_G_Soldier_TL_F"];
_markerArray = ["aaf_hvt","aaf_hvt_1","aaf_hvt_2","aaf_hvt_3","aaf_hvt_4","aaf_hvt_5","aaf_hvt_6","aaf_hvt_7","aaf_hvt_8","aaf_hvt_9","aaf_hvt_10","aaf_hvt_11"];



if(true)exitWith{};
