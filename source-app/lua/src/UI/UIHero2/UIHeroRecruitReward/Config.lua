local UIHeroRecruitReward = {
  Name = UIWindowNames.UIHeroRecruitReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UIHeroRecruitReward.Controller.UIHeroRecruitRewardCtrl"),
  View = require("UI.UIHero2.UIHeroRecruitReward.View.UIHeroRecruitReward"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroRecruitReward.prefab"
}
return {UIHeroRecruitReward = UIHeroRecruitReward}
