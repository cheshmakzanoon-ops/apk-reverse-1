local UIMainAccountBind = {
  Name = UIWindowNames.UIMainAccountBind,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMainAccountBind.Controller.UIMainAccountBindCtrl"),
  View = require("UI.UIMainAccountBind.View.UIMainAccountBindView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMain/UIMainAccountBind.prefab"
}
return {UIMainAccountBind = UIMainAccountBind}
