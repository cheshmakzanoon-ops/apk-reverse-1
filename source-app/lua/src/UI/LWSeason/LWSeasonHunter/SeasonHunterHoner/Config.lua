local SeasonHunterHoner = {
  Name = UIWindowNames.SeasonHunterHoner,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonHunter.SeasonHunterHoner.SeasonHunterHonerCtrl"),
  View = require("UI.LWSeason.LWSeasonHunter.SeasonHunterHoner.SeasonHunterHonerView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Hunter/SeasonHunterHoner.prefab"
}
return {SeasonHunterHoner = SeasonHunterHoner}
