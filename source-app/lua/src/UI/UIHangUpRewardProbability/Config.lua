local UIHangUpRewardProbability = {
  Name = UIWindowNames.UIHangUpRewardProbability,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHangUpRewardProbability.Controller.UIHangUpRewardProbabilityCtrl"),
  View = require("UI.UIHangUpRewardProbability.View.UIHangUpRewardProbabilityView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWStage/UIHangUpRewardProbability.prefab"
}
return {UIHangUpRewardProbability = UIHangUpRewardProbability}
