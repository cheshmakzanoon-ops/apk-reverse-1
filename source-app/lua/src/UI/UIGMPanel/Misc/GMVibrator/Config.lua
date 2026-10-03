local UIGMVibratorPanel = {
  Name = UIWindowNames.UIGMVibratorPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGMPanel.Misc.GMVibrator.UIGMVibratorPanelCtrl"),
  View = require("UI.UIGMPanel.Misc.GMVibrator.UIGMVibratorPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGMPanel/GMVibrator/UIGMVibratorPanel.prefab"
}
return {UIGMVibratorPanel = UIGMVibratorPanel}
