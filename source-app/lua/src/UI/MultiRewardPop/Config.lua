local UIMultiRewardPop = {
  Name = UIWindowNames.UIMultiRewardPop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.MultiRewardPop.Ctrl.UIMultiRewardPopCtrl"),
  View = require("UI.MultiRewardPop.View.UIMultiRewardPopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/MultiReward/UIMultiRewardPop.prefab"
}
return {UIMultiRewardPop = UIMultiRewardPop}
