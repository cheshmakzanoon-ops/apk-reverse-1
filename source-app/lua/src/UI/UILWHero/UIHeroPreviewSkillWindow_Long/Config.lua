local UIHeroPreviewSkillWindow_Long = {
  Name = UIWindowNames.UIHeroPreviewSkillWindow_Long,
  Layer = UILayer.Normal,
  Ctrl = require("UI/UILWHero/UIHeroPreviewSkillWindow_Long/Controller/UIHeroPreviewSkillWindowLongCtrl"),
  View = require("UI/UILWHero/UIHeroPreviewSkillWindow_Long/View/UIHeroPreviewSkillWindowLongView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroPreviewSkillWindow_Long.prefab"
}
return {UIHeroPreviewSkillWindow_Long = UIHeroPreviewSkillWindow_Long}
