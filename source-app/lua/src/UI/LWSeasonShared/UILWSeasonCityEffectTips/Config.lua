local UILWSeasonCityEffectTips = {
  Name = UIWindowNames.UILWSeasonCityEffectTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeasonShared.UILWSeasonCityEffectTips.Controller.UILWSeasonCityEffectTipsCtrl"),
  View = require("UI.LWSeasonShared.UILWSeasonCityEffectTips.View.UILWSeasonCityEffectTipsView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/SeasonCityEffectTips.prefab"
}
return {UILWSeasonCityEffectTips = UILWSeasonCityEffectTips}
