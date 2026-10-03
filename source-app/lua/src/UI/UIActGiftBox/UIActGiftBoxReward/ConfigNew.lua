local UIActGiftBoxRewardNew = {
  Name = UIWindowNames.UIActGiftBoxRewardNew,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActGiftBox.UIActGiftBoxReward.Controller.UIActGiftBoxRewardCtrl"),
  View = require("UI.UIActGiftBox.UIActGiftBoxReward.View.UIActGiftBoxRewardViewNew"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/GiftBox/UIActGiftBoxRewardNew.prefab"
}
return {UIActGiftBoxRewardNew = UIActGiftBoxRewardNew}
