local UISpeedUpConfirm = {
  Name = UIWindowNames.UISpeedUpConfirm,
  Layer = UILayer.Dialog,
  Ctrl = require("UI.UISpeedUpConfirm.Controller.UISpeedUpConfirmCtrl"),
  View = require("UI.UISpeedUpConfirm.View.UISpeedUpConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISpeedUpConfirm/UISpeedUpConfirm.prefab"
}
return {UISpeedUpConfirm = UISpeedUpConfirm}
