local UIActEpidemicBattleBuffView = {
  Name = UIWindowNames.UIActEpidemicBattleBuffView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActEpidemicPopup.Ctrl.UIActEpidemicBattleBuffCtrl"),
  View = require("UI.UIActEpidemicPopup.View.UIActEpidemicBattleBuffView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicBattleBuffView.prefab"
}
return {UIActEpidemicBattleBuffView = UIActEpidemicBattleBuffView}
