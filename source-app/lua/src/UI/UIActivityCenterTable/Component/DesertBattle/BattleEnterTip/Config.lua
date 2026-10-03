local UIDesertBattleEnterTip = {
  Name = UIWindowNames.UIDesertBattleEnterTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleEnterTip.Controller.UIDesertBattleEnterTipCtrl"),
  View = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleEnterTip.View.UIDesertBattleEnterTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/BattleEnterTip.prefab"
}
return {UIDesertBattleEnterTip = UIDesertBattleEnterTip}
