local UIFormationLackPower = {
  Name = UIWindowNames.UIFormationLackPower,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFormationLackPower.Controller.UIFormationLackPowerCtrl"),
  View = require("UI.UIFormationLackPower.View.UIFormationLackPowerView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIFormationLackPower.prefab"
}
return {UIFormationLackPower = UIFormationLackPower}
