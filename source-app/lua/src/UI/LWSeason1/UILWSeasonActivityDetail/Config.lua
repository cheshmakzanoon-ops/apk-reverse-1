local UILWSeasonActivityDetail = {
  Name = UIWindowNames.UILWSeasonActivityDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason1.UILWSeasonActivityDetail.Controller.UILWSeasonActivityDetailCtrl"),
  View = require("UI.LWSeason1.UILWSeasonActivityDetail.View.UILWSeasonActivityDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/ActivityDetail.prefab"
}
return {UILWSeasonActivityDetail = UILWSeasonActivityDetail}
