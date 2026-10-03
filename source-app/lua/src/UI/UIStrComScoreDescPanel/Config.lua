local UIStrComScoreDescPanel = {
  Name = UIWindowNames.UIStrComScoreDescPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIStrComScoreDescPanel.Controller.UIStrComScoreDescPanelCtrl"),
  View = require("UI.UIStrComScoreDescPanel.View.UIStrComScoreDescPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/StrongestCommander/UIStrComScoreDescPanel.prefab"
}
return {UIStrComScoreDescPanel = UIStrComScoreDescPanel}
