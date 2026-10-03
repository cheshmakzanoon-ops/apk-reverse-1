local UIDispatchTaskMain = {
  Name = UIWindowNames.UIDispatchTaskMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Main.Controller.UIDispatchTaskMainCtrl"),
  View = require("UI.UIDispatchTask.Main.View.UIDispatchTaskMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/DispatchTask/UIDispatchTaskMain.prefab",
  HideBack = true
}
return {UIDispatchTaskMain = UIDispatchTaskMain}
