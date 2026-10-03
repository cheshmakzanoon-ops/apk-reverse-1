local SeasonPhotoMessageOperation = {
  Name = UIWindowNames.SeasonPhotoMessageOperation,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonPhoto.SeasonPhotoMessageOperation.Controller.SeasonPhotoMessageOperationCtrl"),
  View = require("UI.LWSeason.LWSeasonPhoto.SeasonPhotoMessageOperation.View.SeasonPhotoMessageOperationView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/SeasonPhoto/SeasonPhotoMessageOperation.prefab"
}
return {SeasonPhotoMessageOperation = SeasonPhotoMessageOperation}
