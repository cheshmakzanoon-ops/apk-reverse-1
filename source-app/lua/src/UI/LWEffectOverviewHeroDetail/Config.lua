local LWEffectOverviewHeroDetail = {
  Name = UIWindowNames.LWEffectOverviewHeroDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWEffectOverviewHeroDetail.Controller.LWEffectOverviewHeroDetailCtrl"),
  View = require("UI.LWEffectOverviewHeroDetail.View.LWEffectOverviewHeroDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWEffectOverview/LWEffectOverviewHeroDetail.prefab"
}
return {LWEffectOverviewHeroDetail = LWEffectOverviewHeroDetail}
