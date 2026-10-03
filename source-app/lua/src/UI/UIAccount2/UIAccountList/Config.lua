local UIAccountList = {
  Name = UIWindowNames.UIAccountList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UIAccountList.Controller.UIAccountListCtrl"),
  View = require("UI.UIAccount2.UIAccountList.View.UIAccountList"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIAccountList.prefab"
}
return {UIAccountList = UIAccountList}
