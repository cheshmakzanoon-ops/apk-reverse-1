local SeasonPhotoMessage = {
  Name = UIWindowNames.SeasonPhotoMessage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonPhoto.SeasonPhotoMessage.SeasonPhotoMessageCtrl"),
  View = require("UI.LWSeason.LWSeasonPhoto.SeasonPhotoMessage.SeasonPhotoMessageView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/SeasonPhoto/SeasonPhotoMessage.prefab"
}
return {SeasonPhotoMessage = SeasonPhotoMessage}
