local UIParkourFormationPanel = {
  Name = UIWindowNames.UIParkourFormation,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIParkour.FormationUI.Controller.UIParkourFormationPanelCtrl"),
  View = require("UI.UIParkour.FormationUI.View.UIParkourFormationPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ParkourBattle/UIParkourFormationPanel.prefab"
}
return {UIParkourFormationPanel = UIParkourFormationPanel}
