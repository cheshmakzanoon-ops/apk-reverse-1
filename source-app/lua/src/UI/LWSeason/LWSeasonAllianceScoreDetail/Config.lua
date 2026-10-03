local LWSeasonAllianceScoreDetail = {
  Name = UIWindowNames.LWSeasonAllianceScoreDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonAllianceScoreDetail.Controller.LWSeasonAllianceScoreDetailCtrl"),
  View = require("UI.LWSeason.LWSeasonAllianceScoreDetail.View.LWSeasonAllianceScoreDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonAllianceScoreDetail.prefab"
}
return {LWSeasonAllianceScoreDetail = LWSeasonAllianceScoreDetail}
