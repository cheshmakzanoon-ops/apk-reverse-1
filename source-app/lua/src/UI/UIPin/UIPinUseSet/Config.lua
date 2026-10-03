local UIPinUseSet = {
  Name = UIWindowNames.UIPinUseSet,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPin.UIPinUseSet.Controller.UIPinUseSetCtrl"),
  View = require("UI.UIPin.UIPinUseSet.View.UIPinUseSetView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPin/UIPinUseSet.prefab"
}
return {UIPinUseSet = UIPinUseSet}
