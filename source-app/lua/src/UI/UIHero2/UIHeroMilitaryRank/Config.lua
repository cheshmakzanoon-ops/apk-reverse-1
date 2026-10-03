local UIHeroMilitaryRank = {
  Name = UIWindowNames.UIHeroMilitaryRank,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIHero2.UIHeroMilitaryRank.Controller.UIHeroMilitaryRankCtrl"),
  View = require("UI.UIHero2.UIHeroMilitaryRank.View.UIHeroMilitaryRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroMilitaryRank.prefab"
}
return {UIHeroMilitaryRank = UIHeroMilitaryRank}
