local UIActEpidemicBattleHistoryView = {
  Name = UIWindowNames.UIActEpidemicBattleHistoryView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActEpidemicPopup.Ctrl.UIActEpidemicBattleHistoryCtrl"),
  View = require("UI.UIActEpidemicPopup.View.UIActEpidemicBattleHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicBattleHistoryView.prefab"
}
return {UIActEpidemicBattleHistoryView = UIActEpidemicBattleHistoryView}
