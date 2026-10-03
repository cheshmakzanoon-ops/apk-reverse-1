local UIHeroJigsawReward = {
  Name = UIWindowNames.UIHeroJigsawReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UIHeroJigsawReward.Controller.UIHeroJigsawRewardCtrl"),
  View = require("UI.UIHero2.UIHeroJigsawReward.View.UIHeroJigsawReward"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroJigsawReward.prefab"
}
return {UIHeroJigsawReward = UIHeroJigsawReward}
