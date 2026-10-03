local UIAllyDuelGroupTip = {
  Name = UIWindowNames.UIAllyDuelGroupTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllyDuelGroupTip.Controller.UIAllyDuelGroupTipCtrl"),
  View = require("UI.UIAllyDuelGroupTip.View.UIAllyDuelGroupTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllyDuel/UIAllyDuelGroupTipPanel.prefab"
}
return {UIAllyDuelGroupTip = UIAllyDuelGroupTip}
