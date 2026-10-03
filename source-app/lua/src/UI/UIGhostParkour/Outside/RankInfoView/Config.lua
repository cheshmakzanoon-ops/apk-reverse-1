local UIGhostParkourRankPageView = {
  Name = UIWindowNames.UIGhostParkourRankPageView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGhostParkour.Outside.RankInfoView.Ctrl.UIGhostParkourRankPageCtrl"),
  View = require("UI.UIGhostParkour.Outside.RankInfoView.View.UIGhostParkourRankPageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GhostParkourBattle/OutsideUI/UIGhostParkourRankPageView.prefab"
}
return {UIGhostParkourRankPageView = UIGhostParkourRankPageView}
