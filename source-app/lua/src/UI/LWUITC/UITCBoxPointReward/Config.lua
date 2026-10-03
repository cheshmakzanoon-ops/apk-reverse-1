local UITCBoxPointReward = {
  Name = UIWindowNames.UITCBoxPointReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUITC.UITCBoxPointReward.Ctrl.UITCBoxPointRewardCtrl"),
  View = require("UI.LWUITC.UITCBoxPointReward.View.UITCBoxPointRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/CardBoxTip/UITCBoxPointReward.prefab"
}
return {UITCBoxPointReward = UITCBoxPointReward}
