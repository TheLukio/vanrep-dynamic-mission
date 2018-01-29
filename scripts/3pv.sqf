this setHit [getText(configFile >> "cfgVehicles" >> "I_MRAP_03_F" >> "HitPoints" >> "HitRBWheel" >> "name"),1];

this animateDoor ["Door_LF", 1, true]; this animateDoor ["Door_RF", 1, true];
this setHit [getText(configFile >> "cfgVehicles" >> "I_MRAP_03_F" >> "HitPoints" >> "HitGlass1" >> "name"),0.7];
this setHit [getText(configFile >> "cfgVehicles" >> "I_MRAP_03_F" >> "HitPoints" >> "HitRFWheel" >> "name"),1];
this setHit [getText(configFile >> "cfgVehicles" >> "I_MRAP_03_F" >> "HitPoints" >> "HitRF2Wheel" >> "name"),1];
this setHit [getText(configFile >> "cfgVehicles" >> "I_MRAP_03_F" >> "HitPoints" >> "HitRF2Wheel" >> "name"),1];
this setHit [getText(configFile >> "cfgVehicles" >> "I_MRAP_03_F" >> "HitPoints" >> "HitEngine" >> "name"),1];
this setHit [getText(configFile >> "cfgVehicles" >> "I_MRAP_03_F" >> "HitPoints" >> "HitBody" >> "name"),1];


onEachFrame {

    if(cameraOn == vehicle player) then {

        if(vehicle player == player) then {

            if(driver vehicle player == player) then {

                if(cameraView == "EXTERNAL") then {

                    player switchCamera "INTERNAL";

                };

            };

        };

    };

};
