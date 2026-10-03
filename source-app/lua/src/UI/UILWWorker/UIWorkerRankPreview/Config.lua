local UIWorkerRankPreview = {
  Name = UIWindowNames.UIWorkerRankPreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWWorker.UIWorkerRankPreview.Controller.UIWorkerRankPreviewCtrl"),
  View = require("UI.UILWWorker.UIWorkerRankPreview.View.UIWorkerRankPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIWorker/UIWorkerRankPreview.prefab"
}
return {UIWorkerRankPreview = UIWorkerRankPreview}
