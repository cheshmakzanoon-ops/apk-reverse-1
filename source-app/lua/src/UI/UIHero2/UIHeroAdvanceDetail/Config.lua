local UIHeroAdvanceDetail = {
  Name = UIWindowNames.UIHeroAdvanceDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UIHeroAdvanceDetail.Controller.UIHeroAdvanceDetailCtrl"),
  View = require("UI.UIHero2.UIHeroAdvanceDetail.View.UIHeroAdvanceDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroAdvanceDetail.prefab"
}
return {UIHeroAdvanceDetail = UIHeroAdvanceDetail}
