local SeasonCampDestroyNotice = {
  Name = UIWindowNames.SeasonCampDestroyNotice,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.SeasonCampDestroy.DestroyNotice.SeasonCampDestroyNoticeCtrl"),
  View = require("UI.LWSeason6.SeasonCampDestroy.DestroyNotice.SeasonCampDestroyNoticeView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/SeasonCampDestroy/SeasonCampDestroyNoticeView.prefab"
}
return {SeasonCampDestroyNotice = SeasonCampDestroyNotice}
