local SeasonHunterResult = {
  Name = UIWindowNames.SeasonHunterResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonHunter.SeasonHunterResult.SeasonHunterResultCtrl"),
  View = require("UI.LWSeason.LWSeasonHunter.SeasonHunterResult.SeasonHunterResultView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Hunter/SeasonHunterResult.prefab"
}
return {SeasonHunterResult = SeasonHunterResult}
