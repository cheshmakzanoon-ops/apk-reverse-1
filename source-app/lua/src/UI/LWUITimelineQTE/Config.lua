local LWUITimelineQTE = {
  Name = UIWindowNames.LWUITimelineQTE,
  Layer = UILayer.TimelineInteraction,
  Ctrl = require("UI.LWUITimelineQTE.Controller.LWUITimelineQTECtrl"),
  View = require("UI.LWUITimelineQTE.View.LWUITimelineQTEView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITimelineQTE/LWUITimelineQTE.prefab"
}
return {LWUITimelineQTE = LWUITimelineQTE}
