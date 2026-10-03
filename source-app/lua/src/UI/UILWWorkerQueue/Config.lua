local UILWWorkerQueue = {
  Name = UIWindowNames.UILWWorkerQueue,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWWorkerQueue.Controller.UILWWorkerQueueCtrl"),
  View = require("UI.UILWWorkerQueue.View.UILWWorkerQueueView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWWorkerQueue/UILWWorkerQueue.prefab"
}
return {UILWWorkerQueue = UILWWorkerQueue}
