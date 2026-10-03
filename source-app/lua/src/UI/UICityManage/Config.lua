local UICityManage = {
  Name = UIWindowNames.UICityManage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICityManage.Controller.UICityManageCtrl"),
  View = require("UI.UICityManage.View.UICityManageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/CityManage/UICityManage.prefab"
}
return {UICityManage = UICityManage}
