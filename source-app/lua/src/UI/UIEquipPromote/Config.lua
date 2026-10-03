local UIEquipPromote = {
  Name = UIWindowNames.UIEquipPromote,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIEquipPromote.Controller.UIEquipPromoteCtrl"),
  View = require("UI.UIEquipPromote.View.UIEquipPromoteView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIEquip/UIEquipPromote.prefab",
  HideBack = true,
  CustomKeyCodeEscape = true
}
return {UIEquipPromote = UIEquipPromote}
