local SeasonPhotoCanvaShare = {
  Name = UIWindowNames.SeasonPhotoCanvaShare,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonPhoto.SeasonPhotoCanvaShare.SeasonPhotoCanvaShareCtrl"),
  View = require("UI.LWSeason.LWSeasonPhoto.SeasonPhotoCanvaShare.SeasonPhotoCanvaShareView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/SeasonPhoto/SeasonPhotoCanvaShare.prefab"
}
return {SeasonPhotoCanvaShare = SeasonPhotoCanvaShare}
