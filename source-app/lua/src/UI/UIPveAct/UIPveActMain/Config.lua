local UIPositionTip = {
  Name = UIWindowNames.UIPveActMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPveAct.UIPveActMain.Controller.UIPveActMainCtrl"),
  View = require("UI.UIPveAct.UIPveActMain.View.UIPveActMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPveAct/UIPveActMain.prefab"
}
return {UIPositionTip = UIPositionTip}
