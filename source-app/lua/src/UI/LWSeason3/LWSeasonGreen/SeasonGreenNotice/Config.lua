local SeasonGreenNotice = {
  Name = UIWindowNames.SeasonGreenNotice,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason3.LWSeasonGreen.SeasonGreenNotice.SeasonGreenNoticeCtrl"),
  View = require("UI.LWSeason3.LWSeasonGreen.SeasonGreenNotice.SeasonGreenNoticeView"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/SeasonActivity/SeasonGreen/SeasonGreenNotice.prefab"
}
return {SeasonGreenNotice = SeasonGreenNotice}
