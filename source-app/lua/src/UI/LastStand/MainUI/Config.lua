local UILastStandMain = {
  Name = UIWindowNames.UILastStandMain,
  Layer = UILayer.Background,
  Ctrl = require("UI.LastStand.MainUI.Controller.UILastStandMainCtrl"),
  View = require("UI.LastStand.MainUI.View.UILastStandMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LastStand/UILastStandMain.prefab"
}
return {UILastStandMain = UILastStandMain}
