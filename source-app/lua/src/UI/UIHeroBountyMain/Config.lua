local UIHeroBountyMain = {
  Name = UIWindowNames.UIHeroBountyMain,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIHeroBountyMain.Controller.UIHeroBountyMainCtrl"),
  View = require("UI.UIHeroBountyMain.View.UIHeroBountyMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroOfferRewardFirst.prefab"
}
return {UIHeroBountyMain = UIHeroBountyMain}
