local UIActivityDecorationGachaGetReward = {
  Name = UIWindowNames.UIActivityDecorationGachaGetReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActivityDecorationGacha.GetReward.Ctrl.ActivityDecorationGachaGetRewardCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActivityDecorationGacha.GetReward.View.ActivityDecorationGachaGetRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DecorationGacha/UIDecorationGachaGetReward.prefab"
}
return {UIActivityDecorationGachaGetReward = UIActivityDecorationGachaGetReward}
