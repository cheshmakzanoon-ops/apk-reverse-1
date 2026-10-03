local UILWSeasonCityOccupyListS3 = {
  Name = UIWindowNames.UILWSeasonCityOccupyListS3,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason3.UILWSeasonCityOccupyListS3.Controller.UILWSeasonCityOccupyListS3Ctrl"),
  View = require("UI.LWSeason3.UILWSeasonCityOccupyListS3.View.UILWSeasonCityOccupyListS3View"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/UICityOccupyListS3.prefab",
  HideBack = true
}
return {UILWSeasonCityOccupyListS3 = UILWSeasonCityOccupyListS3}
