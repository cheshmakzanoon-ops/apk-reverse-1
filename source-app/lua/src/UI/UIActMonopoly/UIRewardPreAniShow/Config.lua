local UIRewardPreAniShow = {
  Name = UIWindowNames.UIRewardPreAniShow,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActMonopoly.UIRewardPreAniShow.Controller.UIRewardPreAniShowCtrl"),
  View = require("UI.UIActMonopoly.UIRewardPreAniShow.View.UIRewardPreAniShowView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/UIRewardPreAniShow.prefab"
}
return {UIRewardPreAniShow = UIRewardPreAniShow}
