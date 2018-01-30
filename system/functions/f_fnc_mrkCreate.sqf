params["_mrkname","_posAO","_size1","_size2","_shape","_color"];

    //name, position, x-size,y-size,shape,color
    private _mrk_ao = createMarker [_mrkname, _posAO];
    _mrk_ao setMarkerSize [_size1,_size2]; // defaults 100x100
    _mrk_ao setMarkerShape _shape; // RECTANGLE,ELLIPSE (default Ellipse)
    _mrk_ao setMarkerColor _color; // ColorCIV, colorBLUFOR, colorOPFOR (default colorBlufor) colorIndependent
    _mrk_ao setMarkerBrush "SolidBorder";
    _mrk_ao setMarkerAlpha 0.33;



if (_shape == "ELLIPSE" || _shape == "RECTANGLE") then {
    //code
  for "_i" from 0 to 3 do
    {
       _size1 = _size1 + (_size1 * 0.0025);
       _size2 = _size2 + (_size2 * 0.0025);

       _mrkname = format [_mrk_ao,_i];
       _mrkname = createMarker [format["mrkAO%1",_i], _posAO];
       _mrkname setMarkerSize [_size1, _size2];
       _mrkname setMarkerShape _shape;
       _mrkname setMarkerColor _color;
       _mrkname setMarkerBrush "Border";
       _mrkname setMarkerAlpha 0.66;
    };
};
