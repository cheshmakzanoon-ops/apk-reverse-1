local UIPVEDebug = {
  Name = UIWindowNames.UIPVEDebug,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPVE.UIPVEDebug.Controller.UIPVEDebugCtrl"),
  View = require("UI.UIPVE.UIPVEDebug.View.UIPVEDebugView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVEDebug.prefab"
}
return {UIPVEDebug = UIPVEDebug}
