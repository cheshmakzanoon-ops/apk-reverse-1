local UIBindMailTips = {
  Name = UIWindowNames.UIBindMailTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UIBindMailTips.Ctrl.UIBindMailTipsCtrl"),
  View = require("UI.UIAccount2.UIBindMailTips.View.UIBindMailTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UIBindMailTips.prefab"
}
return {UIBindMailTips = UIBindMailTips}
