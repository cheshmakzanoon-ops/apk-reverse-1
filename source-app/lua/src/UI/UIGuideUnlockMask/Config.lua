local UIGuideUnlockMask = {
  Name = UIWindowNames.UIGuideUnlockMask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGuideUnlockMask.Controller.UIGuideUnlockMaskCtrl"),
  View = require("UI.UIGuideUnlockMask.View.UIGuideUnlockMaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGuideUnlockMask/UIGuideUnlockMask.prefab"
}
return {UIGuideUnlockMask = UIGuideUnlockMask}
