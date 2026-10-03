local UIGhostParkourRankRewardPopView = {
  Name = UIWindowNames.UIGhostParkourRankRewardPopView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGhostParkour.Outside.TypeRankReward.Ctrl.UIGhostParkourRankRewardPopCtrl"),
  View = require("UI.UIGhostParkour.Outside.TypeRankReward.View.UIGhostParkourRankRewardPopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GhostParkourBattle/OutsideUI/UIGhostParkourRankRewardPop.prefab"
}
return {UIGhostParkourRankRewardPopView = UIGhostParkourRankRewardPopView}
