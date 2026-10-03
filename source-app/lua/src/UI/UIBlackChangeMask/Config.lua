local UIBlackChangeMask = {
  Name = UIWindowNames.UIBlackChangeMask,
  Layer = UILayer.Guide,
  Ctrl = require("UI.UIBlackChangeMask.Controller.UIBlackChangeMaskCtrl"),
  View = require("UI.UIBlackChangeMask.View.UIBlackChangeMaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBlackChangeMask/UIBlackChangeMask.prefab"
}
return {UIBlackChangeMask = UIBlackChangeMask}
