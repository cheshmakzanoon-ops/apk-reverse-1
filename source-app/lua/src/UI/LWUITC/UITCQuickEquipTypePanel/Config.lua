local UITCQuickEquipTypePanel = {
  Name = UIWindowNames.UITCQuickEquipTypePanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUITC.UITCQuickEquipTypePanel.Ctrl.UITCQuickEquipTypePanelCtrl"),
  View = require("UI.LWUITC.UITCQuickEquipTypePanel.View.UITCQuickEquipTypePanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/CardDetailItem/QuickEquip/UITCQuickEquipTypePanel.prefab"
}
return {UITCQuickEquipTypePanel = UITCQuickEquipTypePanel}
