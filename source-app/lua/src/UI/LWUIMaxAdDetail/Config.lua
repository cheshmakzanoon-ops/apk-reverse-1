local LWUIMaxAdDetail = {
  Name = UIWindowNames.LWUIMaxAdDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMaxAdDetail.Ctrl.LWMaxAdDetailCtrl"),
  View = require("UI.LWUIMaxAdDetail.View.LWMaxAdDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIMaxAd/LWMaxAdDetail.prefab"
}
return {LWUIMaxAdDetail = LWUIMaxAdDetail}
