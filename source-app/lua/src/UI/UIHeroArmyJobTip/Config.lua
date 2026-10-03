local UIHeroArmyJobTip = {
  Name = UIWindowNames.UIHeroArmyJobTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHeroArmyJobTip.Controller.UIHeroArmyJobTipCtrl"),
  View = require("UI.UIHeroArmyJobTip.View.UIHeroArmyJobTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroArmyJobTip.prefab"
}
return {UIHeroArmyJobTip = UIHeroArmyJobTip}
