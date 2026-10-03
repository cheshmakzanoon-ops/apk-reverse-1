local UIPVELose = {
  Name = UIWindowNames.UIPVELose,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPVE.UIPVELose.Controller.UIPVELoseCtrl"),
  View = require("UI.UIPVE.UIPVELose.View.UIPVELoseView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVELose.prefab"
}
return {UIPVELose = UIPVELose}
