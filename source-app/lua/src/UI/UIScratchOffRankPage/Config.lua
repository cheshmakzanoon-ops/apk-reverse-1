local UIScratchOffRankPage = {
  Name = UIWindowNames.ScratchOffRankPage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIScratchOffRankPage.Controller.UIScratchOffRankPageCtrl"),
  View = require("UI.UIScratchOffRankPage.View.UIScratchOffRankPageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIScratchOffRankPage/ScratchOffRankPage.prefab"
}
return {UIScratchOffRankPage = UIScratchOffRankPage}
