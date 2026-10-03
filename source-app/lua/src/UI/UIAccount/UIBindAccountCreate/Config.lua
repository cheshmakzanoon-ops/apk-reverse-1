local UIBindAccountCreate = {
  Name = UIWindowNames.UIBindAccountCreate,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount.UIBindAccountCreate.Controller.UIBindAccountCreateCtrl"),
  View = require("UI.UIAccount.UIBindAccountCreate.View.UIBindAccountCreateView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIBindAccountCreate.prefab"
}
return {UIBindAccountCreate = UIBindAccountCreate}
