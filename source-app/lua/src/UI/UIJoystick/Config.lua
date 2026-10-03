local UIJoystick = {
  Name = UIWindowNames.UIJoystick,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIJoystick.Controller.UIJoystickCtrl"),
  View = require("UI.UIJoystick.View.UIJoystickView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UIJoystick.prefab"
}
return {UIJoystick = UIJoystick}
