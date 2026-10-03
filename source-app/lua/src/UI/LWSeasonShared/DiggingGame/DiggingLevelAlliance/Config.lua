local DiggingLevelAllianceView = {
  Name = UIWindowNames.DiggingLevelAllianceCView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeasonShared.DiggingGame.DiggingLevelAlliance.DiggingLevelAllianceCCtrl"),
  View = require("UI.LWSeasonShared.DiggingGame.DiggingLevelAlliance.DiggingLevelAllianceCView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/DiggingGame/DiggingLevelAllianceC.prefab"
}
return {DiggingLevelAllianceView = DiggingLevelAllianceView}
