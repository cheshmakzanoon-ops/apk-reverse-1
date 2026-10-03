local LWCommonScoreDetail = {
  Name = UIWindowNames.LWCommonScoreDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWCommonScoreDetail.Controller.LWCommonScoreDetailCtrl"),
  View = require("UI.LWCommonScoreDetail.View.LWCommonScoreDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWCommonScoreDetail/LWCommonScoreDetail.prefab"
}
return {LWCommonScoreDetail = LWCommonScoreDetail}
