local UIPinSet = {
  Name = UIWindowNames.UIPinSet,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPin.UIPinSet.Controller.UIPinSetCtrl"),
  View = require("UI.UIPin.UIPinSet.View.UIPinSetView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPin/UIPinSet.prefab"
}
return {UIPinSet = UIPinSet}
