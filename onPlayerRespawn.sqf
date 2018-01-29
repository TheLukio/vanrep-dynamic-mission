player setVariable ['QS_seated',FALSE];

// reset PP effects
//"colorCorrections" ppEffectAdjust [1.01, 1.18, -0.04, [1.0, 1.4, 0.8, -0.04], [0.55, 0.55, 0.72, 1.35],  [0.699, 1.787, 0.314, 20.03]];
"colorCorrections" ppEffectAdjust [1.18, 1.15, -0.06, [0.9, 1.1, 0.8, -0.05], [0.55, 0.55, 0.72, 1.25],  [0.699, 1.787, 0.314, 20.03]];
"colorCorrections" ppEffectCommit 1;
"colorCorrections" ppEffectEnable true;
