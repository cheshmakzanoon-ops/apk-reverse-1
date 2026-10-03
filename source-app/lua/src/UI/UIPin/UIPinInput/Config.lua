local UIPinInput = {
  Name = UIWindowNames.UIPinInput,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIPin.UIPinInput.Controller.UIPinInputCtrl"),
  View = require("UI.UIPin.UIPinInput.View.UIPinInputView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPin/UIPinInput.prefab"
}
return {UIPinInput = UIPinInput}
