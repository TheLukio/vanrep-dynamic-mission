params = [["_vehList"],["_mrkList"],["_effectsList",false]];


SM_fn_clenaup = {
      _cleanList = _this;
      {
          {
              deleteVehicle _x;
              { deleteVehicle _x; } forEach (nearestObjects [getPosASL _x,[],3]);
          } forEach allMissionObjects _x;
      } forEach _cleanList;
};
