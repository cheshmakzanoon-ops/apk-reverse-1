local UIBlackHoleMask = {
  Name = UIWindowNames.UIBlackHoleMask,
  Layer = UILayer.Guide,
  Ctrl = require("UI.UIBlackHoleMask.Controller.UIBlackHoleMaskCtrl"),
  View = require("UI.UIBlackHoleMask.View.UIBlackHoleMaskView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UIBlackHoleMask.prefab"
}
return {UIBlackHoleMask = UIBlackHoleMask}
