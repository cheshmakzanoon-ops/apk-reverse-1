local UIDispatchTaskRefreshConfirm = {
  Name = UIWindowNames.UIDispatchTaskRefreshConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Confirm.Controller.UIDispatchTaskRefreshConfirmCtrl"),
  View = require("UI.UIDispatchTask.Confirm.View.UIDispatchTaskRefreshConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/DispatchTask/UIDispatchTaskRefreshConfirm.prefab"
}
return {UIDispatchTaskRefreshConfirm = UIDispatchTaskRefreshConfirm}
