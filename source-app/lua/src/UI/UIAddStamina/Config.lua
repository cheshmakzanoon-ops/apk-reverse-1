local UIAddStamina = {
  Name = UIWindowNames.UIAddStamina,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAddStamina.Controller.UIAddStaminaCtrl"),
  View = require("UI.UIAddStamina.View.UIAddStaminaView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIRepairBuildingPopUp.prefab"
}
return {UIAddStamina = UIAddStamina}
