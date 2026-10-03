local UIFormationAddStamina = {
  Name = UIWindowNames.UIFormationAddStamina,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFormation.UIFormationAddStamina.Controller.UIFormationAddStaminaCtrl"),
  View = require("UI.UIFormation.UIFormationAddStamina.View.UIFormationAddStaminaView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFormation/UIFormationAddStamina.prefab"
}
return {UIFormationAddStamina = UIFormationAddStamina}
