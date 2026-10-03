local UIActGiftBoxReward = {
  Name = UIWindowNames.UIActGiftBoxReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActGiftBox.UIActGiftBoxReward.Controller.UIActGiftBoxRewardCtrl"),
  View = require("UI.UIActGiftBox.UIActGiftBoxReward.View.UIActGiftBoxRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/GiftBox/UIActGiftBoxReward.prefab"
}
return {UIActGiftBoxReward = UIActGiftBoxReward}
