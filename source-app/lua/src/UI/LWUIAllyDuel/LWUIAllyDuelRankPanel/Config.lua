local LWUIAllyDuelPersonalRankPanel = {
  Name = UIWindowNames.LWUIAllyDuelPersonalRankPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIAllyDuel.LWUIAllyDuelRankPanel.Controller.LWUIAllyDuelPersonalRankPanelCtrl"),
  View = require("UI.LWUIAllyDuel.LWUIAllyDuelRankPanel.View.LWUIAllyDuelPersonalRankPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllyDuel/UIAllyDuelPersonalRankPanel.prefab"
}
return {LWUIAllyDuelPersonalRankPanel = LWUIAllyDuelPersonalRankPanel}
