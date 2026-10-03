local UILWMailSeasonRewardView = {
  Name = UIWindowNames.UILWMailSeasonRewardView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWMail.UILWMailSeasonReward.Controller.UILWMailSeasonRewardCtrl"),
  View = require("UI.UILWMail.UILWMailSeasonReward.View.UILWMailSeasonRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWMail/UILWMailSeasonRewardView.prefab"
}
return {UILWMailSeasonRewardView = UILWMailSeasonRewardView}
