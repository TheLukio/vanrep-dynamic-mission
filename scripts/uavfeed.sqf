_object = Monitor1;
_object setObjectTextureglobal [0,"img\vrstandby.jpg"];
waituntil{sleep 1; !Isnil "extraction_point"};

/* create render surface */
_poi = "Land_HelipadEmpty_F" createVehicle extraction_point;
//_poi = getMarkerPos mrkHvtPickup;

/* create uav and make it fly */
uav = createVehicle ["I_UAV_01_F", _poi modelToWorld [0,0,550], [], 0, "FLY"];
createVehicleCrew uav;
uav lockCameraTo [_poi, [0]];
uav flyInHeight 450;

/* add loiter waypoint */
_wp = group uav addWaypoint [position _poi, 0];
_wp setWaypointType "LOITER";
_wp setWaypointLoiterType "CIRCLE_L";
_wp setWaypointLoiterRadius 100;
[group uav,1] setWaypointSpeed "LIMITED";

/* create camera and stream to render surface */
cam = "camera" camCreate [0,0,0];
cam cameraEffect ["Internal", "Back", "uavrtt"];

/* attach cam to gunner cam position */
cam attachTo [uav, [0,0,0], "PiP0_pos"];

/* make it zoom in a little */
cam camSetFov 0.3;

/* switch cam to thermal */
"uavrtt" setPiPEffect [2];

/* adjust cam orientation */
addMissionEventHandler ["Draw3D", {
    _dir =
        (uav selectionPosition "PiP0_pos")
            vectorFromTo
        (uav selectionPosition "PiP0_dir");
    cam setVectorDirAndUp [
        _dir,
        _dir vectorCrossProduct [-(_dir select 1), _dir select 0, 0]
    ];
}];
//_object setObjectTexture [0,"Wasp_Intro_Last_Render.ogv"];

_object = Monitor1;

with uiNamespace do {
	disableSerialization;
    _object setObjectTexture [0,"scripts\uavintro.ogv"];
    1100 cutRsc ["RscMissionScreen","PLAIN"];
    _scr = BIS_RscMissionScreen displayCtrl 1100;
    _scr ctrlSetPosition [-10,-10,0,0];
    _scr ctrlSetText "scripts\uavintro.ogv";
    _scr ctrlAddEventHandler ["VideoStopped", {
	}];
    _scr ctrlCommit 0;
	uiSleep 15;
	_object setObjectTexture [0, "#(argb,512,512,1)r2t(uavrtt,1)"];
};
