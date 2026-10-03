local ArrowTipEnumtype = {}
ArrowTipEnumtype.Type = {
  Default = 0,
  HeroSimpleTip = 1,
  HeroPropertyDetailTip = 2,
  OffSeason1RecaptureBuffTip = 3,
  TreasureBoxTimeTip = 4,
  FirstPayHeroTip = 5
}
ArrowTipEnumtype.ParamClass = {
  [ArrowTipEnumtype.Type.Default] = "DataCenter.ArrowTipParamManager.UIArrowTipBaseParam",
  [ArrowTipEnumtype.Type.HeroSimpleTip] = "DataCenter.ArrowTipParamManager.UIHeroSimpleTipParam",
  [ArrowTipEnumtype.Type.HeroPropertyDetailTip] = "DataCenter.ArrowTipParamManager.Params.UIHeroPropertyTipParam",
  [ArrowTipEnumtype.Type.OffSeason1RecaptureBuffTip] = "DataCenter.ArrowTipParamManager.Params.UIOffSeason1RecaptureBuffTipParam",
  [ArrowTipEnumtype.Type.TreasureBoxTimeTip] = "DataCenter.ArrowTipParamManager.Params.TreasureBoxTimeTipParam",
  [ArrowTipEnumtype.Type.FirstPayHeroTip] = "DataCenter.ArrowTipParamManager.Params.UIFirstPayHeroTipParam"
}
return ArrowTipEnumtype
