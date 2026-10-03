local UIRobotPack = {
  Name = UIWindowNames.UIRobotPack,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIRobotPack.Controller.UIRobotPackCtrl"),
  View = require("UI.UIRobotPack.View.UIRobotPackView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIRobotPack/UIRobotPack.prefab"
}
return {UIRobotPack = UIRobotPack}
