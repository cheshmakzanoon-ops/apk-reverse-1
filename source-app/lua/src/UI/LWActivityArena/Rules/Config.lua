local LWActivityArenaRules = {
  Name = UIWindowNames.LWActivityArenaRules,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWActivityArena.Rules.LWActivityArenaRulesCtrl"),
  View = require("UI.LWActivityArena.Rules.LWActivityArenaRulesView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ArenaNewbie/UIActivityArenaRules.prefab"
}
return {LWActivityArenaRules = LWActivityArenaRules}
