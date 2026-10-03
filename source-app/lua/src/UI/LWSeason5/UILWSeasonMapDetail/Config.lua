local UILWSeasonMapDetail = {
  Name = UIWindowNames.UILWSeasonMapDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.UILWSeasonMapDetail.Controller.UILWSeasonMapDetailCtrl"),
  View = require("UI.LWSeason5.UILWSeasonMapDetail.View.UILWSeasonMapDetailView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/LWSeason5/SeasonMapDetail.prefab"
}
return {UILWSeasonMapDetail = UILWSeasonMapDetail}
