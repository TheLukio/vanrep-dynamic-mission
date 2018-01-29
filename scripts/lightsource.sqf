// create yellow-white lightsource for buildings

_light = _this select 0;
_intensity = _this select 1;
_light setPosATL[(getPosATL _light select 0), (getPosATL _light select 1), 1.8];
BIS_lightEmitor01 = "#lightpoint" createVehicleLocal getPosATL _light;  
BIS_lightEmitor01 setLightColor [1, 0.9, 0.7];
BIS_lightEmitor01 setLightBrightness _intensity;
//BIS_lightEmitor01 setLightAmbient [0.1,0.2,0];
BIS_lightEmitor01 lightAttachObject [_light, [0, 0, 0.1]];