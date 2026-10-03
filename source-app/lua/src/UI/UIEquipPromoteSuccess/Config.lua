local UIEquipPromoteSuccess = {
  Name = UIWindowNames.UIEquipPromoteSuccess,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIEquipPromoteSuccess.Controller.UIEquipPromoteSuccessCtrl"),
  View = require("UI.UIEquipPromoteSuccess.View.UIEquipPromoteSuccessView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIEquip/UIEquipPromoteSuccess.prefab"
}
return {UIEquipPromoteSuccess = UIEquipPromoteSuccess}
