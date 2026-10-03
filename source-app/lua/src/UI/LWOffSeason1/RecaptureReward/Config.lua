local UIOffSeason1RecaptureReward = {
  Name = UIWindowNames.UIOffSeason1RecaptureReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWOffSeason1.RecaptureReward.Controller.UIOffSeason1RecaptureRewardCtrl"),
  View = require("UI.LWOffSeason1.RecaptureReward.View.UIOffSeason1RecaptureRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWOffSeason1/Recapture/OffSeason1RecaptureReward.prefab"
}
return {UIOffSeason1RecaptureReward = UIOffSeason1RecaptureReward}
