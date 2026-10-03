local SeasonHunterConvert = {
  Name = UIWindowNames.SeasonHunterConvert,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonHunter.SeasonHunterConvert.SeasonHunterConvertCtrl"),
  View = require("UI.LWSeason.LWSeasonHunter.SeasonHunterConvert.SeasonHunterConvertView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Hunter/SeasonHunterConvert.prefab"
}
return {SeasonHunterConvert = SeasonHunterConvert}
