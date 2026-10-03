local SeasonHunterResult = {
  Name = UIWindowNames.SeasonHunterMVP,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonHunter.SeasonHunterMVP.SeasonHunterMVPCtrl"),
  View = require("UI.LWSeason.LWSeasonHunter.SeasonHunterMVP.SeasonHunterMVPView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Hunter/SeasonHunterMVP.prefab"
}
return {SeasonHunterResult = SeasonHunterResult}
