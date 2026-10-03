local UIPing = {
  Name = UIWindowNames.UIPing,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISetting.UIPing.Controller.UIPingCtrl"),
  View = require("UI.UISetting.UIPing.View.UIPingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UIPing.prefab"
}
return {UIPing = UIPing}
