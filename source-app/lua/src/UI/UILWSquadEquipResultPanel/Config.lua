local UILWSquadEquipResultPanel = {
  Name = UIWindowNames.UILWSquadEquipResultPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWSquadEquipResultPanel.Controller.UILWSquadEquipResultPanelCtrl"),
  View = require("UI.UILWSquadEquipResultPanel.View.UILWSquadEquipResultPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWSquadEquip/UILWSquadEquipResultPanel.prefab"
}
return {UILWSquadEquipResultPanel = UILWSquadEquipResultPanel}
