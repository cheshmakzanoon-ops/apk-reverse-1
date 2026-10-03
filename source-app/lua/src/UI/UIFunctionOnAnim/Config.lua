local UIFunctionOnAnim = {
  Name = UIWindowNames.UIFunctionOnAnim,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFunctionOnAnim.Controller.UIFunctionOnAnimCtrl"),
  View = require("UI.UIFunctionOnAnim.View.UIFunctionOnAnimView"),
  PrefabPath = "Assets/Main/Prefabs/UI/FunctionOnAnim/UIFunctionOnAnim.prefab"
}
return {UIFunctionOnAnim = UIFunctionOnAnim}
