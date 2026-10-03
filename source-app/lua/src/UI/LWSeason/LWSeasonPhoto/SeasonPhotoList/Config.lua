local SeasonPhotoList = {
  Name = UIWindowNames.SeasonPhotoList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonPhoto.SeasonPhotoList.SeasonPhotoListCtrl"),
  View = require("UI.LWSeason.LWSeasonPhoto.SeasonPhotoList.SeasonPhotoListView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/SeasonPhoto/SeasonPhotoList.prefab"
}
return {SeasonPhotoList = SeasonPhotoList}
