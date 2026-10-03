local UIArena3V3BattleResult = {
  Name = UIWindowNames.UIArena3V3BattleResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIArena3V3BattleResult.Controller.UIArena3V3BattleResultCtrl"),
  View = require("UI.UIArena3V3BattleResult.View.UIArena3V3BattleResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPVPArena/LW3V3BattleResultPanel.prefab",
  CustomKeyCodeEscape = true
}
return {UIArena3V3BattleResult = UIArena3V3BattleResult}
