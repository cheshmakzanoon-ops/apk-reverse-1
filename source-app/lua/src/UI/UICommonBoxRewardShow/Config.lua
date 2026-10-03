local UICommonBoxRewardShow = {
  Name = UIWindowNames.UICommonBoxRewardShow,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICommonBoxRewardShow.Controller.UICommonBoxRewardShowCtrl"),
  View = require("UI.UICommonBoxRewardShow.View.UICommonBoxRewardShowView"),
  PrefabPath = "Assets/Main/Prefabs/UI/CommonBoxReward/UICommonBoxRewardShow.prefab"
}
return {UICommonBoxRewardShow = UICommonBoxRewardShow}
