local UIGhostParkourRankGuideView = {
  Name = UIWindowNames.UIGhostParkourRankGuideView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGhostParkour.Outside.RankInfoGuide.Ctrl.UIGhostParkourRankGuideCtrl"),
  View = require("UI.UIGhostParkour.Outside.RankInfoGuide.View.UIGhostParkourRankGuideView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GhostParkourBattle/OutsideUI/UIGhostParkourRankGuide.prefab"
}
return {UIGhostParkourRankGuideView = UIGhostParkourRankGuideView}
