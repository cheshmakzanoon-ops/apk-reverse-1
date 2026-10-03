local UIWorldPoint = {
  Name = UIWindowNames.UIWorldPoint,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIWorldPoint.Controller.UIWorldPointCtrl"),
  View = require("UI.UIWorldPoint.View.UIWorldPointView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIWorldPointNew.prefab"
}
return {UIWorldPoint = UIWorldPoint}
