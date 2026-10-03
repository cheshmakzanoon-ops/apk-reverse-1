local UIAccountManage = {
  Name = UIWindowNames.UIAccountManage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccountManage.Ctrl.UIAccountManageCtrl"),
  View = require("UI.UIAccountManage.View.UIAccountManageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccountManage/UIAccountManage.prefab",
  HideBack = true
}
return {UIAccountManage = UIAccountManage}
