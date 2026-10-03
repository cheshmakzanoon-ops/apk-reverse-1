local UIEpidemicBattleEnterTip = {
  Name = UIWindowNames.UIEpidemicBattleEnterTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleEnterTip.Controller.UIEpidemicBattleEnterTipCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleEnterTip.View.UIEpidemicBattleEnterTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/BattleEnterTip.prefab"
}
return {UIEpidemicBattleEnterTip = UIEpidemicBattleEnterTip}
