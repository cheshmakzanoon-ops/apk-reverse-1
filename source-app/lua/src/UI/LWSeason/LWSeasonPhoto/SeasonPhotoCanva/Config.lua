local SeasonPhotoCanva = {
  Name = UIWindowNames.SeasonPhotoCanva,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonPhoto.SeasonPhotoCanva.SeasonPhotoCanvaCtrl"),
  View = require("UI.LWSeason.LWSeasonPhoto.SeasonPhotoCanva.SeasonPhotoCanvaView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/SeasonPhoto/SeasonPhotoCanva.prefab",
  CustomKeyCodeEscape = true
}
return {SeasonPhotoCanva = SeasonPhotoCanva}
