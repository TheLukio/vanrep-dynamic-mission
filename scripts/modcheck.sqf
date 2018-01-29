waitUntil {!isNull (findDisplay 46)};
waitUntil {!dialog};

sleep 6;

if(getText(configFile >> "cfgWeapons" >> "LMG_mas_Mk200_F_a" >> "displayname") isEqualTo "")then{
    _att = format["[WARNING %1!]",name player];
    _att hintC [
        parseText "<t shadow='2' size='3'align='center'color='#cf2e4e'>You are Missing: </t><br/><t shadow='2' size='1.75'align='center'color='#b0eb00'>@MAS @NATO_Rus_Vehicle </t><br/><br/><t shadow='2'align='center' size='1.25'>These mods add a lot to the game!</t><br/><t shadow='2'align='center'>You can continue to play on this server without them, but for a much better experience it's recommended you download:</t>",
        parseText "<t shadow='2'size='1.1' >Mas Nato and Russian Weapon Pack.</t><br/><a shadow='2'size='0.8'align='center' href='http://www.armaholic.com/page.php?id=21912'>http://www.armaholic.com/page.php?id=21912</a>",
        parseText "<t shadow='2'size='1.1' >Mas Nato and Russian Vehicles Pack.</t><br/><a shadow='2'size='0.8'align='center' href='http://www.armaholic.com/page.php?id=27652'>http://www.armaholic.com/page.php?id=27652</a>
        <br/><br/><t shadow='2'size='1.1'>Those addresses can be clicked for a direct link, or get them from the Steam Workshop or the Arma3 launcher</t><br/><br/><t shadow='2'align='center'size='1.75'color='#3d94af'>See you in game!</t>"
    ];
};
