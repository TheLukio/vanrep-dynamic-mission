// by psycho
if (isDedicated) exitWith {};

_subject = player createDiarySubject ["ais", "First Aid System"];
_log_briefing = player createDiaryRecord ["ais", ["About and Credits", "
<font face='PuristaMedium' color='#ffffff'>Made by: </font><font face='PuristaMedium' size=14 color='#155EB3'>Psychobastard</font><br/>
<font face='PuristaMedium' color='#ffffff'>Version: </font><font face='PuristaMedium' color='#ffffff'>21022016</font><br/><br/>

<font face='PuristaMedium' size=14 color='#155EB3'>Credits</font><br/>
- <font face='PuristaMedium'color='#8E8E8E'>BonInf*</font> for the first multiplayer compatible version (Arma 2)<br/>
- <font face='PuristaMedium' color='#8E8E8E'>EightSix</font> for his PatrolOps and the included status bar<br/>
- <font face='PuristaMedium' color='#8E8E8E'>BI</font> for the design idea (Wounding module Arma 2)<br/>
- <font face='PuristaMedium' color='#8E8E8E'>Alwarren</font> for his feedback and fixes<br/>
- <font face='PuristaMedium' color='#8E8E8E'>lukio</font> for his text revisions and better translations
"]];
_log_briefing = player createDiaryRecord ["ais", ["Instructions:", "
<font face='PuristaMedium' size=14 color='#155EB3'>If you are unconscious:</font><br/>
* <font face='PuristaMedium' color='#FBC819'>Press 'forward'</font> to go prone and fire your current weapon.<br/><br/>
* You can <font face='PuristaMedium' color='#FBC819'>crawl</font> to a safe position.<br/><br/>
* <font face='PuristaMedium' color='#FBC819'>Press 'H'</font> key to call friendly AI for help.<br/><br/>
* <font face='PuristaMedium' color='#FBC819'>You cannot</font> reload, throw grenades, change weapons, board vehicles or take any other actions.<br/><br/><br/>

<font face='PuristaMedium' size=14 color='#155EB3'>How to give first aid:</font><br/><br/>
* Move close to an unconscious unit and select <font face='PuristaMedium' color='#FBC819'>'First Aid'</font> to help (Mousewheel menu).<br/><br/>
* Move close to an unconscious unit and select <font face='PuristaMedium' color='#FBC819'>'Drag'</font> to drag the body out of the line of fire (Mousewheel menu).<br/><br/>
* While you are dragging a unit, you can select <font face='PuristaMedium' color='#FBC819'>'Carry'</font> to carry the unit on your shoulders (better to cover long distances).<br/><br/>
* Move close to an unconscious unit and select <font face='PuristaMedium' color='#FBC819'>'Press on wound'</font> to stop further bleeding and wait until a medic is present (Mousewheel menu).<br/><br/>
* In some cases you need medical equipment (First Aid Kit or Medkit) or must be a medic to start the 'First aid' action.<br/><br/>
"]];
_log_briefing = player createDiaryRecord ["ais", ["About wounding / death:", "
* If a unit receives too much damage, the <font face='PuristaMedium' color='#FBC819'>unit goes unconscious</font>. This means that the unit starts to <font face='PuristaMedium' color='#FBC819'>bleed out and needs help</font> from other units.<br/><br/>
* If someone comes <font face='PuristaMedium' color='#FBC819'>to help, he can stop the bleeding</font> and <font face='PuristaMedium' color='#FBC819'>heal the wounded unit</font>. The remaining damage after the first aid process depends on several factors (Was the attendant a medic? What kind of medical equipment was used?).<br/><br/>
* If nobody comes to help <font face='PuristaMedium' color='#FBC819'>the unit eventually bleeds out</font>. The time depends on the amount of damage the unit received.<br><br/>
* If you are not able to start the first aid process for some reason, you still have <font face='PuristaMedium' color='#FBC819'>the option to press on the wound</font>. While you are pressing on the wound, the unit will stop bleeding (increase lifetime).
"]];
_log_briefing = player createDiaryRecord ["ais", ["Description:", "
<font face='PuristaMedium' size=14 color='#155EB3'>Psycho's Wounding System</font><br/><br/>
This First Aid System (AIS = Alternative Injury System) is an alternative system to all the current normal revive scripts.<br/><br/>
The main difference to a standard revive system is that the unit does not die before going into a state of agony. If critical damage level is reached, the unit goes unconscious and does not immediately die like in most other systems. The advantage: You can use it in missions without a revive option as well!<br/><br/>
Another advantage of the system is that if a unit is gravely wounded and waiting for others to help, the wounded unit is not completely defenseless. A wounded unit can go prone, crawl and use a weapon as last stand (until the magazine is empty).
AIS also supports AI. AI soldiers can be unconscious or give first aid as well.
"]];

true
