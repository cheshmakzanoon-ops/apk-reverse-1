local LWSeasonDesertTip = {
  Name = UIWindowNames.LWSeasonDesertTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonDesertTip.Controller.LWSeasonDesertTipCtrl"),
  View = require("UI.LWSeason.LWSeasonDesertTip.View.LWSeasonDesertTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonDesertTip.prefab"
}
return {LWSeasonDesertTip = LWSeasonDesertTip}
