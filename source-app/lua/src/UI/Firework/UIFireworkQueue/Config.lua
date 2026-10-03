local UIFireworkQueue = {
  Name = UIWindowNames.UIFireworkQueue,
  Layer = UILayer.Normal,
  Ctrl = require("UI.Firework.UIFireworkQueue.Controller.UIFireworkQueueCtrl"),
  View = require("UI.Firework.UIFireworkQueue.View.UIFireworkQueueView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIFirework/UIFireworkQueueView.prefab"
}
return {UIFireworkQueue = UIFireworkQueue}
