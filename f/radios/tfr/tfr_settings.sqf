// F3 - TFR Settings
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// Initialise TFAR
compile preprocessFileLineNumbers "\task_force_radio\functions\common.sqf";

//#include "\task_force_radio\functions\common.sqf";

// Serious mode
// RADIO STRUCTURE
//Serious mode
tf_radio_channel_name = "TaskForceRadio";
tf_radio_channel_password = "123";

// general settings
// Whether long range radios are automatically added
tf_no_auto_long_range_radio = true;

// Should a side use the same short-wave frequencies
tf_same_sw_frequencies_for_side = true;
// Should a side use the same long-wave frequencies
tf_same_lr_frequencies_for_side = true;
// Whether short range programmable radios are automatically added
tf_give_personal_radio_to_regular_soldier = false;
tf_give_microdagr_to_soldier = true;

// distance of speaker
tf_speakerDistance = 20;

// terrain intercept
tf_terrain_interception_coefficient = 6.0;

// Whether any radios should be assigned at all, to any units
// TRUE = Disable radios for all units
f_radios_settings_tfr_disableRadios = FALSE;

// Which units should be given LR backpacks
// TRUE = all group leaders get backpacks
// FALSE = only units defined in next variable will get LR backpacks
f_radios_settings_tfr_defaultLRBackpacks = FALSE;

// Unit types you want to give long-range radios if previous is
// E.G: ["co", "m"] would give the CO and all medics 2 long-range radios
f_radios_settings_tfr_backpackRadios = ["co","dc","m"];

// Independent radio encryption code: Independent faction use radio code of side
// they are friendly to if they are only friendly to one side.
f_radios_settings_tfr_indepUseRadioCode = FALSE;

// Variable broadcasting
if (isServer) then {
publicVariable "tf_no_auto_long_range_radio";
publicVariable "tf_give_personal_radio_to_regular_soldier";
publicVariable "TF_give_microdagr_to_soldier";
publicVariable "tf_same_sw_frequencies_for_side";
publicVariable "tf_same_lr_frequencies_for_side";
publicVariable "tf_terrain_interception_coefficient";
publicVariable "tf_west_radio_code";
publicVariable "tf_defaultWestBackpack";
publicVariable "tf_defaultWestPersonalRadio";
publicVariable "tf_defaultWestRiflemanRadio";
publicVariable "tf_defaultWestAirborneRadio";
publicVariable "tf_east_radio_code";
publicVariable "tf_defaultEastBackpack";
publicVariable "tf_defaultEastPersonalRadio";
publicVariable "tf_defaultEastRiflemanRadio";
publicVariable "tf_defaultEastAirborneRadio";
publicVariable "tf_guer_radio_code";
publicVariable "tf_defaultGuerBacpkpack";
publicVariable "tf_defaultGuerPersonalRadio";
publicVariable "tf_defaultGuerRiflemanRadio";
publicVariable "tf_defaultGuerAirborneRadio";
publicVariable "tf_freq_west";
publicVariable "tf_freq_west_lr";
publicVariable "tf_freq_east";
publicVariable "tf_freq_east_lr";
publicVariable "tf_freq_guer";
publicVariable "tf_freq_guer_lr";
publicVariable "tf_freq_name";

};
