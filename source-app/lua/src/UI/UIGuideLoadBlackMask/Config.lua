local UIGuideLoadBlackMask = {
  Name = UIWindowNames.UIGuideLoadBlackMask,
  Layer = UILayer.Guide,
  Ctrl = require("UI.UIGuideLoadBlackMask.Controller.UIGuideLoadBlackMaskCtrl"),
  View = require("UI.UIGuideLoadBlackMask.View.UIGuideLoadBlackMaskView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UIGuideLoadBlackMask.prefab"
}
return {UIGuideLoadBlackMask = UIGuideLoadBlackMask}
