local TCCardEquipConfirm = {
  Name = UIWindowNames.TCCardEquipConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUITCCardEquipConfirm.Ctrl.TCCardEquipConfirmCtrl"),
  View = require("UI.LWUITCCardEquipConfirm.View.TCCardEquipConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/TCCardEquipConfirm.prefab"
}
return {TCCardEquipConfirm = TCCardEquipConfirm}
