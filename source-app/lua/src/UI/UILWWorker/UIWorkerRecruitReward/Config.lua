local UIWorkerRecruitReward = {
  Name = UIWindowNames.UIWorkerRecruitReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWWorker.UIWorkerRecruitReward.Controller.UIWorkerRecruitRewardCtrl"),
  View = require("UI.UILWWorker.UIWorkerRecruitReward.View.UIWorkerRecruitReward"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIWorker/UIWorkerRecruitReward.prefab"
}
return {UIWorkerRecruitReward = UIWorkerRecruitReward}
