params ["_tskObject",["_taskDesc", "_taskTitle"],["_tskParent",false,true],"_tskLocation",["_type","MOVE",""]];

private ["_tskName","_taskTitle"];
  // called after mission success / fail, mission generator waits till completed

  // check to see if it has a parent task / is child task
  if (_tskParent) then {
    _tskName = [format ["tsk_%1",_taskTitle],_tskParent];
  }
  else {
      tskName = format ["tsk_%1",_taskTitle];
   };

  // create task
    [_tskObject,[_tskName],[_taskDesc,_taskTitle,""],[_tskLocation],"AUTOASSIGNED",0,false,_type,true] call BIS_fnc_taskCreate;
