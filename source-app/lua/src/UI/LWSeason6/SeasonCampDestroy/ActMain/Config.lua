local SeasonCampDestroyMain = {
  Name = UIWindowNames.SeasonCampDestroyMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.SeasonCampDestroy.ActMain.SeasonCampDestroyMainCtrl"),
  View = require("UI.LWSeason6.SeasonCampDestroy.ActMain.SeasonCampDestroyMain"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/SeasonCampDestroy/SeasonCampDestroyMain.prefab",
  HideBack = true
}
return {SeasonCampDestroyMain = SeasonCampDestroyMain}
