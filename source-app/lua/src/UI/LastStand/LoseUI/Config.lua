local UILastStandLose = {
  Name = UIWindowNames.UILastStandLose,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LastStand.LoseUI.Controller.UILastStandLoseCtrl"),
  View = require("UI.LastStand.LoseUI.View.UILastStandLoseView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LastStand/LastStandLosePanel.prefab"
}
return {UILastStandLose = UILastStandLose}
