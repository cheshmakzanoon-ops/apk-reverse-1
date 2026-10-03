local UIPermanentTips = {
  Name = UIWindowNames.UIPermanentTips,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIPermanentTips.Controller.UIPermanentTipsCtrl"),
  View = require("UI.UIPermanentTips.View.UIPermanentTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UIPermanentTips.prefab"
}
return {UIPermanentTips = UIPermanentTips}
