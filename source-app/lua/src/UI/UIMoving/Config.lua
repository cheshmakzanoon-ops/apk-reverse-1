local UIMoving = {
  Name = UIWindowNames.UIMoving,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMoving.Controller.UIMovingCtrl"),
  View = require("UI.UIMoving.View.UIMovingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIMoving.prefab"
}
return {UIMoving = UIMoving}
