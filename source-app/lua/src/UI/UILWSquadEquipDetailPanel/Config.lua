local UILWSquadEquipDetailPanel = {
  Name = UIWindowNames.UILWSquadEquipDetailPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWSquadEquipDetailPanel.Controller.UILWSquadEquipDetailPanelCtrl"),
  View = require("UI.UILWSquadEquipDetailPanel.View.UILWSquadEquipDetailPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWSquadEquip/UILWSquadEquipDetailPanel.prefab"
}
return {UILWSquadEquipDetailPanel = UILWSquadEquipDetailPanel}
