local LWDevelopRecommend = {
  Name = UIWindowNames.LWDevelopRecommend,
  Layer = UILayer.Normal,
  Ctrl = require("UI/LWDevelopRecommend/Controller/LWDevelopRecommendCtrl"),
  View = require("UI/LWDevelopRecommend/View/LWDevelopRecommendView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPowerOverview/DevelopRecommend/LWDevelopRecommend.prefab"
}
return {LWDevelopRecommend = LWDevelopRecommend}
