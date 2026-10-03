local UIAllyDuelConditionTip = {
  Name = UIWindowNames.UIAllyDuelConditionTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllyDuelConditionTip.Controller.UIAllyDuelConditionTipCtrl"),
  View = require("UI.UIAllyDuelConditionTip.View.UIAllyDuelConditionTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllyDuel/UIAllyDuelConditionTipPanel.prefab"
}
return {UIAllyDuelConditionTip = UIAllyDuelConditionTip}
