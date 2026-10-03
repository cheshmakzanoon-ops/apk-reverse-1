local UIPositionShare = {
  Name = UIWindowNames.UIPositionShare,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPositionShare.Controller.UIPositionShareCtrl"),
  View = require("UI.UIPositionShare.View.UIPositionShareView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIPositionShare.prefab"
}
return {UIPositionShare = UIPositionShare}
