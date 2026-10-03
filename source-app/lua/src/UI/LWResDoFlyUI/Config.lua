local UIMain = {
  Name = UIWindowNames.LWResDoFlyUI,
  Layer = UILayer.Info,
  Ctrl = require("UI.LWResDoFlyUI.Controller.LWResDoFlyUICtrl"),
  View = require("UI.LWResDoFlyUI.View.LWResDoFlyUIView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/LWResDoFlyUI.prefab"
}
return {UIMain = UIMain}
