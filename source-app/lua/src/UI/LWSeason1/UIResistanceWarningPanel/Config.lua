local UIResistanceWarningPanel = {
  Layer = UILayer.Normal,
  Name = UIWindowNames.UIResistanceWarningPanel,
  Ctrl = require("UI.LWSeason1.UIResistanceWarningPanel.Controller.UIResistanceWarningPanelCtrl"),
  View = require("UI.LWSeason1.UIResistanceWarningPanel.View.UIResistanceWarningPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/UIResistanceWarningPanel.prefab"
}
return {UIResistanceWarningPanel = UIResistanceWarningPanel}
