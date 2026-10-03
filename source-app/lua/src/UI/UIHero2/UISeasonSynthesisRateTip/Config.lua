local UISeasonSynthesisRateTip = {
  Name = UIWindowNames.UISeasonSynthesisRateTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UISeasonSynthesisRateTip.Controller.UISeasonSynthesisRateTipCtrl"),
  View = require("UI.UIHero2.UISeasonSynthesisRateTip.View.UISeasonSynthesisRateTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UISeasonSynthesisRateTip.prefab"
}
return {UISeasonSynthesisRateTip = UISeasonSynthesisRateTip}
