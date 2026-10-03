local UISeasonBattlePass = {
  Name = UIWindowNames.UISeasonBattlePass,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeasonShared.UIBattlePass.Controller.UISeasonBattlePassCtrl"),
  View = require("UI.LWSeasonShared.UIBattlePass.View.UISeasonBattlePassView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/BattlePass/UISeasonBattlePass.prefab"
}
return {UISeasonBattlePass = UISeasonBattlePass}
