local UIPinForget = {
  Name = UIWindowNames.UIPinForget,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPin.UIPinForget.Controller.UIPinForgetCtrl"),
  View = require("UI.UIPin.UIPinForget.View.UIPinForgetView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPin/UIPinForget.prefab"
}
return {UIPinForget = UIPinForget}
