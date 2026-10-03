local TCCardEquip = {
  Name = UIWindowNames.TCCardEquip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUITCCardEquip.Ctrl.UITCCardEquipCardPanelCtrl"),
  View = require("UI.LWUITCCardEquip.View.UITCCardEquipCardPanel"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/UITCCardEquipCardPanel.prefab"
}
return {TCCardEquip = TCCardEquip}
