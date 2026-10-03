local UIPVEGainBuff = {
  Name = UIWindowNames.UIPVEGainBuff,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPVE.UIPVEGainBuff.Controller.UIPVEGainBuffCtrl"),
  View = require("UI.UIPVE.UIPVEGainBuff.View.UIPVEGainBuffView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVEGainBuff.prefab"
}
return {UIPVEGainBuff = UIPVEGainBuff}
