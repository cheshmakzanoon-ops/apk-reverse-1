local UIReachLimit = {
  Name = UIWindowNames.UIReachLimit,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIReachLimit.Controller.UIReachLimitCtrl"),
  View = require("UI.UIReachLimit.View.UIReachLimitView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BusinessCenter/UIReachLimit.prefab"
}
return {UIReachLimit = UIReachLimit}
