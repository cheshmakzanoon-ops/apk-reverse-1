local LWCommonHeroCardShowConfig = {
  Name = UIWindowNames.UILWCommonHeroCardShow,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWCommonHeroCardShow.Controller.LWCommonHeroCardShowCtrl"),
  View = require("UI.LWSeason.LWCommonHeroCardShow.View.LWComonHeroCardShowView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/HeroPromotion/UIComonShowHeroCardPanel.prefab"
}
return {LWCommonHeroCardShowConfig = LWCommonHeroCardShowConfig}
