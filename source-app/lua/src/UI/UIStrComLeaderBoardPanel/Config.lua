local UIStrComLeaderBoardPanel = {
  Name = UIWindowNames.UIStrComLeaderBoardPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIStrComLeaderBoardPanel.Controller.UIStrComLeaderBoardPanelCtrl"),
  View = require("UI.UIStrComLeaderBoardPanel.View.UIStrComLeaderBoardPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/StrongestCommander/UIStrComLeaderBoardPanel.prefab"
}
return {UIStrComLeaderBoardPanel = UIStrComLeaderBoardPanel}
