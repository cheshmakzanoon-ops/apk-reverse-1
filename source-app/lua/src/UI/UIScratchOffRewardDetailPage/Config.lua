local ScratchOffRewardDetailPage = {
  Name = UIWindowNames.ScratchOffRewardDetailPage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIScratchOffRewardDetailPage.Ctrl.UIScratchOffRewardDetailPageCtrl"),
  View = require("UI.UIScratchOffRewardDetailPage.View.UIScratchOffRewardDetailPageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIScratchOffRewardDetailPage/ScratchOffRewardDetailPage.prefab"
}
return {ScratchOffRewardDetailPage = ScratchOffRewardDetailPage}
