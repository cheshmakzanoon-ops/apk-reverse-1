local UIGuideLoadMask = {
  Name = UIWindowNames.UIGuideLoadMask,
  Layer = UILayer.Guide,
  Ctrl = require("UI.UIGuideLoadMask.Controller.UIGuideLoadMaskCtrl"),
  View = require("UI.UIGuideLoadMask.View.UIGuideLoadMaskView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UIGuideLoadMask.prefab"
}
return {UIGuideLoadMask = UIGuideLoadMask}
