local UILWActDetectTreasureALPanel = {
  Name = UIWindowNames.UILWActDetectTreasureALPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActMonopoly.UILWActDetectTreasureALPanel.Controller.UILWActDetectTreasureALPanelCtrl"),
  View = require("UI.UIActMonopoly.UILWActDetectTreasureALPanel.View.UILWActDetectTreasureALPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/ActDetectTreasure/UILWActDetectTreasureALPanel.prefab"
}
return {UILWActDetectTreasureALPanel = UILWActDetectTreasureALPanel}
