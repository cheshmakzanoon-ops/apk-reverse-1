local UIPVEMain = {
  Name = UIWindowNames.UIPVEMain,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIPVE.UIPVEMain.Controller.UIPVEMainCtrl"),
  View = require("UI.UIPVE.UIPVEMain.View.UIPVEMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVEMainTable.prefab"
}
return {UIPVEMain = UIPVEMain}
