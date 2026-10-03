local UIParkourFormation_HeroTryOut = {
  Name = UIWindowNames.UIParkourFormation_HeroTryOut,
  Layer = UILayer.Normal,
  Ctrl = require("UI/UILWHero/UILWHeroTryOut/UILWHeroTryOutParkourFormation/Controller/UIParkourFormationPanelCtrl_HeroTryOut"),
  View = require("UI/UILWHero/UILWHeroTryOut/UILWHeroTryOutParkourFormation/View/UIParkourFormationPanelView_HeroTryOut"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/UILWHeroTryOut/UIParkourFormationPanel_HeroTryOut.prefab"
}
return {UIParkourFormation_HeroTryOut = UIParkourFormation_HeroTryOut}
