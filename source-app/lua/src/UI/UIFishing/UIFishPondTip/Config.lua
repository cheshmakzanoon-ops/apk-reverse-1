local UIFishPondTip = {
  Name = UIWindowNames.UIFishPondTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFishing.UIFishPondTip.UIFishPondTipCtrl"),
  View = require("UI.UIFishing.UIFishPondTip.UIFishPondTipView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/Fishing/UIFishPondTip.prefab"
}
return {UIFishPondTip = UIFishPondTip}
