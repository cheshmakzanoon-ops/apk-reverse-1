local UIPVESelectBuff = {
  Name = UIWindowNames.UIPVESelectBuff,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPVE.UIPVESelectBuff.Controller.UIPVESelectBuffCtrl"),
  View = require("UI.UIPVE.UIPVESelectBuff.View.UIPVESelectBuffView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVESelectBuff.prefab"
}
return {UIPVESelectBuff = UIPVESelectBuff}
