local UIAllyDrillMvpTip = {
  Name = UIWindowNames.UIAllyDrillMvpTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllyDrill.UIAllyDrillMvpTip.Controller.UIAllyDrillMvpTipCtrl"),
  View = require("UI.UIAllyDrill.UIAllyDrillMvpTip.View.UIAllyDrillMvpTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/AllyDrill/UIAllyDrillMvpTip.prefab"
}
return {UIAllyDrillMvpTip = UIAllyDrillMvpTip}
