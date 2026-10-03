local SeasonPhotoCanvaMenuView = {
  Name = UIWindowNames.SeasonPhotoCanvaMenuView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonPhoto.SeasonPhotoCanvaMenu.SeasonPhotoCanvaMenuCtrl"),
  View = require("UI.LWSeason.LWSeasonPhoto.SeasonPhotoCanvaMenu.SeasonPhotoCanvaMenuView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/SeasonPhoto/SeasonPhotoCanvaMenu.prefab"
}
return {SeasonPhotoCanvaMenuView = SeasonPhotoCanvaMenuView}
