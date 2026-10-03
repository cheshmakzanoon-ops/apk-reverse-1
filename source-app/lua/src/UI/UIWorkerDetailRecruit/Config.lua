local UIWorkerDetailRecruit = {
  Name = UIWindowNames.UIWorkerDetailRecruit,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIWorkerDetailRecruit.Controller.UIWorkerDetailRecruitCtrl"),
  View = require("UI.UIWorkerDetailRecruit.View.UIWorkerDetailRecruitView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIWorker/UIWorkerDetailRecruit.prefab"
}
return {UIWorkerDetailRecruit = UIWorkerDetailRecruit}
