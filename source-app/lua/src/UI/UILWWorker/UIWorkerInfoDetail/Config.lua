local UIWorkerInfoDetail = {
  Name = UIWindowNames.UIWorkerInfoDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWWorker.UIWorkerInfoDetail.Controller.UIWorkerInfoDetailCtrl"),
  View = require("UI.UILWWorker.UIWorkerInfoDetail.View.UIWorkerInfoDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIWorker/UIWorkerInfoDetail.prefab"
}
return {UIWorkerInfoDetail = UIWorkerInfoDetail}
