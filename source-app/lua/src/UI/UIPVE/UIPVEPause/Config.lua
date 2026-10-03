local UIPVEPause = {
  Name = UIWindowNames.UIPVEPause,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIPVE.UIPVEPause.Controller.UIPVEPauseCtrl"),
  View = require("UI.UIPVE.UIPVEPause.View.UIPVEPauseView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVEPause.prefab"
}
return {UIPVEPause = UIPVEPause}
