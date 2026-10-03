local UILWSquadEquipPanel = {
  Name = UIWindowNames.UILWSquadEquipPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWSquadEquipPanel.Controller.UILWSquadEquipPanelCtrl"),
  View = require("UI.UILWSquadEquipPanel.View.UILWSquadEquipPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWSquadEquip/UILWSquadEquipPanel.prefab"
}
return {UILWSquadEquipPanel = UILWSquadEquipPanel}
