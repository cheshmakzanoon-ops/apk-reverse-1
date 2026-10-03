local UIActEpidemicRewardView = {
  Name = UIWindowNames.UIActEpidemicRewardView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActEpidemicPopup.Ctrl.UIActEpidemicRewardCtrl"),
  View = require("UI.UIActEpidemicPopup.View.UIActEpidemicRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicRewardView.prefab"
}
return {UIActEpidemicRewardView = UIActEpidemicRewardView}
