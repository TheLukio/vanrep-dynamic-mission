params = ["_tskObject",["_taskDesc", "_taskTitle"],["_tskParent",false,true],"_tskLocation",["_type","MOVE",""]];
  // called after mission success / fail, mission generator waits till completed
  // create default rtb task
  _taskStringRtb = localize "RTB_TASK";
  _taskDescRtb = localize "RTB_TITLE";

  // check to see if it has a parent task / is child task
  if (_tskParent) {
    _tskName = [format ["tsk_%1",_taskTitle],_tskParent];
    }
    else {
    _tskName = format ["tsk_%1",_taskTitle;
    };

  // create task
  [
   _tskObject //BOOL or OBJECT or GROUP or SIDE or ARRAY - Task owner(s)
   _tskName, //Task name
   this select 1 params [_taskDesc, _taskTitle]; // defaults 100x100
   [_taskString, _taskDesc,""], // description, title, marker
   _tskLocation, // task destination = marker
   "AUTOASSIGNED", //task state
   0, // priority
   false, // notification popup
   _type, // task type
   true // shared with group
  ] call BIS_fnc_taskCreate;
