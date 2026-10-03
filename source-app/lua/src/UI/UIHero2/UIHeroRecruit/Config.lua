local UIHeroRecruit = {
  Name = UIWindowNames.UIHeroRecruit,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UIHeroRecruit.Controller.UIHeroRecruitCtrl"),
  View = require("UI.UIHero2.UIHeroRecruit.View.UIHeroRecruitView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroRecruit.prefab",
  HideBack = true,
  AcquireHighFPSLocker = true
}
return {UIHeroRecruit = UIHeroRecruit}
