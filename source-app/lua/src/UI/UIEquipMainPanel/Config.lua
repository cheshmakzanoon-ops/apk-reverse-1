local UIEquipMainPanel = {
  Name = UIWindowNames.UIEquipMainPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIEquipMainPanel.Controller.UIEquipMainPanelCtrl"),
  View = require("UI.UIEquipMainPanel.View.UIEquipMainPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIEquip/UIEquipMainPanel.prefab",
  HideBack = true
}
return {UIEquipMainPanel = UIEquipMainPanel}
