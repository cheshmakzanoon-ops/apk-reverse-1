local UILWSeasonScoreDetail = {
  Name = UIWindowNames.UILWSeasonScoreDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.UILWSeasonScoreDetail.Controller.UILWSeasonScoreDetailCtrl"),
  View = require("UI.LWSeason.UILWSeasonScoreDetail.View.UILWSeasonScoreDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/UISeasonScoreDetail.prefab"
}
return {UILWSeasonScoreDetail = UILWSeasonScoreDetail}
