local UIWorkerVipBoxShowTips = {
  Name = UIWindowNames.UIWorkerVipBoxShowTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWWorker.UIWorkerVipBoxShowTips.Controller.UIWorkerVipBoxShowTipsCtrl"),
  View = require("UI.UILWWorker.UIWorkerVipBoxShowTips.View.UIWorkerVipBoxShowTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIWorker/UIWorkerVipBoxShowTips.prefab"
}
return {UIWorkerVipBoxShowTips = UIWorkerVipBoxShowTips}
