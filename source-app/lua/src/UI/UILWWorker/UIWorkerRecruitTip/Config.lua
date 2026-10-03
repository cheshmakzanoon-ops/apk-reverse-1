local UIWorkerRecruitTip = {
  Name = UIWindowNames.UIWorkerRecruitTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWWorker.UIWorkerRecruitTip.Controller.UIWorkerRecruitTipCtrl"),
  View = require("UI.UILWWorker.UIWorkerRecruitTip.View.UIWorkerRecruitTip"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIWorker/UIWorkerRecruitTip.prefab"
}
return {UIWorkerRecruitTip = UIWorkerRecruitTip}
