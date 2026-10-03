local UIBuildQueue = {
  Name = UIWindowNames.UIBuildQueue,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBuildQueue.Controller.UIBuildQueueCtrl"),
  View = require("UI.UIBuildQueue.View.UIBuildQueueView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Build/LWUIBuildQueuePanel.prefab"
}
return {UIBuildQueue = UIBuildQueue}
