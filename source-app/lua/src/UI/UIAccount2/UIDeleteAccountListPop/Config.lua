local UIDeleteAccountListPop = {
  Name = UIWindowNames.UIDeleteAccountListPop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UIDeleteAccountListPop.Controller.UIDeleteAccountListPopCtrl"),
  View = require("UI.UIAccount2.UIDeleteAccountListPop.View.UIDeleteAccountListPopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIDeleteAccountListPop.prefab"
}
return {UIDeleteAccountListPop = UIDeleteAccountListPop}
