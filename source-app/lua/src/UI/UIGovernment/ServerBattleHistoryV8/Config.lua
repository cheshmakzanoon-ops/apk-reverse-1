local UIGovernmentServerBattleHistoryV8 = {
  Name = UIWindowNames.UIGovernmentServerBattleHistoryV8,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.ServerBattleHistoryV8.Controller.ServerBattleHistoryV8Ctrl"),
  View = require("UI.UIGovernment.ServerBattleHistoryV8.View.ServerBattleHistoryV8View"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/ServerBattleHistoryV8.prefab"
}
return {UIGovernmentServerBattleHistoryV8 = UIGovernmentServerBattleHistoryV8}
