local UIDispatchTaskSuperPopup = {
  Name = UIWindowNames.UIDispatchTaskSuperPopup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Popup.Controller.UIDispatchTaskSuperPopupCtrl"),
  View = require("UI.UIDispatchTask.Popup.View.UIDispatchTaskSuperPopupView"),
  PrefabPath = "Assets/Main/Prefabs/UI/DispatchTask/UIDispatchTaskSuperPopup.prefab"
}
return {UIDispatchTaskSuperPopup = UIDispatchTaskSuperPopup}
