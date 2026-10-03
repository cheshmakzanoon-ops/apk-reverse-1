local UISmallTips = {
  Name = UIWindowNames.UISmallTips,
  Layer = UILayer.TopMost,
  Ctrl = require("UI.UISmallTips.Controller.UISmallTipsCtrl"),
  View = require("UI.UISmallTips.View.UISmallTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UISmallTips.prefab"
}
return {UISmallTips = UISmallTips}
