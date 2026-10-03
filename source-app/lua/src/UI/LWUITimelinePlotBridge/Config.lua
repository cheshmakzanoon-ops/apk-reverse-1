local LWUITimelinePlotBridge = {
  Name = UIWindowNames.LWUITimelinePlotBridge,
  Layer = UILayer.TimelineInteraction,
  Ctrl = require("UI.LWUITimelinePlotBridge.Controller.LWUITimelinePlotBridgeCtrl"),
  View = require("UI.LWUITimelinePlotBridge.View.LWUITimelinePlotBridgeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITimelinePlotBridge/LWUITimelinePlotBridge.prefab"
}
return {LWUITimelinePlotBridge = LWUITimelinePlotBridge}
