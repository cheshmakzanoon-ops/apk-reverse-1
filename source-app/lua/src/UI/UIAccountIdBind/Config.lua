local UIAccountIdBind = {
  Name = UIWindowNames.UIAccountIdBind,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccountIdBind.Ctrl.UIAccountIdBindCtrl"),
  View = require("UI.UIAccountIdBind.View.UIAccountIdBindView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccountIdBind/UIAccountIdBind.prefab",
  HideBack = true
}
return {UIAccountIdBind = UIAccountIdBind}
