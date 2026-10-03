local SeasonPhotoReward = {
  Name = UIWindowNames.SeasonPhotoReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonPhoto.SeasonPhotoReward.SeasonPhotoRewardCtrl"),
  View = require("UI.LWSeason.LWSeasonPhoto.SeasonPhotoReward.SeasonPhotoRewardView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/SeasonPhoto/SeasonPhotoReward.prefab"
}
return {SeasonPhotoReward = SeasonPhotoReward}
