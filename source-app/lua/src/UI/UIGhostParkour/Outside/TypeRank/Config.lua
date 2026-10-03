local UIGhostParkourRankPanelView = {
  Name = UIWindowNames.UIGhostParkourRankPanelView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGhostParkour.Outside.TypeRank.Ctrl.UIGhostParkourRankPanelCtrl"),
  View = require("UI.UIGhostParkour.Outside.TypeRank.View.UIGhostParkourRankPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GhostParkourBattle/OutsideUI/UIGhostParkourRankPanel.prefab"
}
return {UIGhostParkourRankPanelView = UIGhostParkourRankPanelView}
