local SeasonPhotoMessageShare = {
  Name = UIWindowNames.SeasonPhotoMessageShare,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonPhoto.SeasonPhotoMessageShare.SeasonPhotoMessageShareCtrl"),
  View = require("UI.LWSeason.LWSeasonPhoto.SeasonPhotoMessageShare.SeasonPhotoMessageShareView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/SeasonPhoto/SeasonPhotoMessageShare.prefab"
}
return {SeasonPhotoMessageShare = SeasonPhotoMessageShare}
