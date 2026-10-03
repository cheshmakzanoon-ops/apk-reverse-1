local UIBFDsbDuelActHistoryPanel = {
  Name = UIWindowNames.UIBFDsbDuelActHistoryPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.BFDsbDuel.BFDsbDuelHistory.Controller.UIBFDsbDuelActHistoryPanelCtrl"),
  View = require("UI.BFDsbDuel.BFDsbDuelHistory.View.UIBFDsbDuelActHistoryPanel"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/History/UIBFDsbDuelActHistoryPanel.prefab"
}
return {UIBFDsbDuelActHistoryPanel = UIBFDsbDuelActHistoryPanel}
