local UIDetectEvent = {
  Name = UIWindowNames.UIDetectEvent,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIRadarCenter.UIDetectEvent.Controller.UIDetectEventCtrl"),
  View = require("UI.UIRadarCenter.UIDetectEvent.View.UIDetectEventView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIRadarCenter/UIDetectEvent.prefab"
}
return {UIDetectEvent = UIDetectEvent}
