local LWUIAllyDuelRewardPanel = {
  Name = UIWindowNames.LWUIAllyDuelRewardPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIAllyDuel.LWUIAllyDuelRewardPanel.Controller.LWUIAllyDuelRewardPanelCtrl"),
  View = require("UI.LWUIAllyDuel.LWUIAllyDuelRewardPanel.View.LWUIAllyDuelRewardPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllyDuel/UIAllyDuelRewardPanel.prefab"
}
return {LWUIAllyDuelRewardPanel = LWUIAllyDuelRewardPanel}
