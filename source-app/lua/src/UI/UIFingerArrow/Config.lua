local UIFingerArrow = {
  Name = UIWindowNames.UIFingerArrow,
  Layer = UILayer.Guide,
  Ctrl = require("UI.UIFingerArrow.Controller.UIFingerArrowCtrl"),
  View = require("UI.UIFingerArrow.View.UIFingerArrowView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UIArrowFinger.prefab"
}
return {UIFingerArrow = UIFingerArrow}
