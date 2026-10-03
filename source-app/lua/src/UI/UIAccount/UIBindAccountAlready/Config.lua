local UIBindAccountAlready = {
  Name = UIWindowNames.UIBindAccountAlready,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount.UIBindAccountAlready.Controller.UIBindAccountAlreadyCtrl"),
  View = require("UI.UIAccount.UIBindAccountAlready.View.UIBindAccountAlreadyView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIBindAccountAlready.prefab"
}
return {UIBindAccountAlready = UIBindAccountAlready}
