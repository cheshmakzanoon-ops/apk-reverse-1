local UIPVEAddEnergy = {
  Name = UIWindowNames.UIPVEAddEnergy,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPVE.UIPVEAddEnergy.Controller.UIPVEAddEnergyCtrl"),
  View = require("UI.UIPVE.UIPVEAddEnergy.View.UIPVEAddEnergyView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVEAddEnergy.prefab"
}
return {UIPVEAddEnergy = UIPVEAddEnergy}
