local UIPVEPowerLack = {
  Name = UIWindowNames.UIPVEPowerLack,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPVE.UIPVEPowerLack.Controller.UIPVEPowerLackCtrl"),
  View = require("UI.UIPVE.UIPVEPowerLack.View.UIPVEPowerLackView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVEPowerLack.prefab"
}
return {UIPVEPowerLack = UIPVEPowerLack}
