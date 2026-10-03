local UIHeroRecruitRewardNew = {
  Name = UIWindowNames.UIHeroRecruitRewardNew,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UIHeroRecruitRewardNew.Controller.UIHeroRecruitRewardCtrl"),
  View = require("UI.UIHero2.UIHeroRecruitRewardNew.View.UIHeroRecruitReward"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroRecruitRewardNew.prefab"
}
return {UIHeroRecruitRewardNew = UIHeroRecruitRewardNew}
