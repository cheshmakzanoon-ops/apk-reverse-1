local UIHeroFakePVPFormation_HeroTryOut = {
  Name = UIWindowNames.UIHeroFakePVPFormation_HeroTryOut,
  Layer = UILayer.Normal,
  Ctrl = require("UI/UILWHero/UILWHeroTryOut/UILWHeroTryOutFakePVPFormation/Controller/UIHeroFakePVPFormationCtrl_HeroTryOut"),
  View = require("UI/UILWHero/UILWHeroTryOut/UILWHeroTryOutFakePVPFormation/View/UIHeroFakePVPFormationView_HeroTryOut"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/UILWHeroTryOut/UIHeroFakePVPFormationPanel_HeroTryOut.prefab"
}
return {UIHeroFakePVPFormation_HeroTryOut = UIHeroFakePVPFormation_HeroTryOut}
