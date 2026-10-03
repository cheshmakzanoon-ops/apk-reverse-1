local UIHeroRecruitChangeCamp = {
  Name = UIWindowNames.UIHeroRecruitChangeCamp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UIHeroRecruitChangeCamp.Controller.UIHeroRecruitChangeCampCtrl"),
  View = require("UI.UIHero2.UIHeroRecruitChangeCamp.View.UIHeroRecruitChangeCamp"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroRecruitChangeCamp.prefab"
}
return {UIHeroRecruitChangeCamp = UIHeroRecruitChangeCamp}
