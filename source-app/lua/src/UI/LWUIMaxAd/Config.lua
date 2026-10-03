local LWUIMaxAd = {
  Name = UIWindowNames.LWUIMaxAd,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMaxAd.Ctrl.LWMaxAdListCtrl"),
  View = require("UI.LWUIMaxAd.View.LWMaxAdListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIMaxAd/LWMaxAdList.prefab"
}
return {LWUIMaxAd = LWUIMaxAd}
