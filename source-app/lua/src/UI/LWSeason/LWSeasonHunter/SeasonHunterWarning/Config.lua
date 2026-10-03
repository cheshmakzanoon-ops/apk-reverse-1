local UICommonMessageSpecialBar = {
  Name = UIWindowNames.SeasonHunterWarning,
  Layer = UILayer.Info,
  Ctrl = require("UI.LWSeason.LWSeasonHunter.SeasonHunterWarning.SeasonHunterWarningCtrl"),
  View = require("UI.LWSeason.LWSeasonHunter.SeasonHunterWarning.SeasonHunterWarningView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Hunter/SeasonHunterWarning.prefab"
}
return {UICommonMessageSpecialBar = UICommonMessageSpecialBar}
