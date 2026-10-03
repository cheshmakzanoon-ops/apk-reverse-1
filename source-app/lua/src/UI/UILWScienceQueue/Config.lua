local UILWScienceQueue = {
  Name = UIWindowNames.UILWScienceQueue,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWScienceQueue.Controller.UILWScienceQueueCtrl"),
  View = require("UI.UILWScienceQueue.View.UILWScienceQueueView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWScience/LWUIScienceQueuePanel.prefab"
}
return {UILWScienceQueue = UILWScienceQueue}
