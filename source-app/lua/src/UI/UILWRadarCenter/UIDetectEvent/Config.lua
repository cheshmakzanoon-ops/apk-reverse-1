local UIDetectEvent = {
  Name = UIWindowNames.UIDetectEvent,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRadarCenter.UIDetectEvent.Controller.UIDetectEventCtrl"),
  View = require("UI.UILWRadarCenter.UIDetectEvent.View.UIDetectEventView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRadarCenter/UIDetectEvent.prefab",
  HideBack = true
}
return {UIDetectEvent = UIDetectEvent}
