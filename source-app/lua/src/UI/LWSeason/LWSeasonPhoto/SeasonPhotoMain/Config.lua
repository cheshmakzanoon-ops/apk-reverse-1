local SeasonPhotoMain = {
  Name = UIWindowNames.SeasonPhotoMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonPhoto.SeasonPhotoMain.SeasonPhotoMainCtrl"),
  View = require("UI.LWSeason.LWSeasonPhoto.SeasonPhotoMain.SeasonPhotoMain"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/SeasonPhoto/SeasonPhotoMain.prefab"
}
return {SeasonPhotoMain = SeasonPhotoMain}
