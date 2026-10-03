local UISoliderGetTip = {
  Name = UIWindowNames.UISoliderGetTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UISoliderGetTip.Controller.UISoliderGetTipCtrl"),
  View = require("UI.UISoliderGetTip.View.UISoliderGetTip"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISoliderGetTip/UISoliderGetTip.prefab"
}
return {UISoliderGetTip = UISoliderGetTip}
