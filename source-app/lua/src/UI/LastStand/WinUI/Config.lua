local UILastStandWin = {
  Name = UIWindowNames.UILastStandWin,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LastStand.WinUI.Controller.UILastStandWinCtrl"),
  View = require("UI.LastStand.WinUI.View.UILastStandWinView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LastStand/LastStandWinPanel.prefab"
}
return {UILastStandWin = UILastStandWin}
