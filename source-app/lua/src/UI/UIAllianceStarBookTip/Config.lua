local UIAllianceStarBookTip = {
  Name = UIWindowNames.UIAllianceStarBookTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllianceStarBookTip.Controller.UIAllianceStarBookTipCtrl"),
  View = require("UI.UIAllianceStarBookTip.View.UIAllianceStarBookTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllianceStar/UIAllianceStarBookTip.prefab"
}
return {UIAllianceStarBookTip = UIAllianceStarBookTip}
