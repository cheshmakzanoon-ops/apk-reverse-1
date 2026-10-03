local UILWRecommendBuildList = {
  Name = UIWindowNames.UILWRecommendBuildList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRecommendBuildList.Ctrl.UILWRecommendBuildListCtrl"),
  View = require("UI.UILWRecommendBuildList.View.UILWRecommendBuildListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWRecommendBuildList/UILWRecommendBuildList.prefab"
}
return {UILWRecommendBuildList = UILWRecommendBuildList}
