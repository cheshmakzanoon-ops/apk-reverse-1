local UIHeroPreviewSkillWindow = {
  Name = UIWindowNames.UIHeroPreviewSkillWindow,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroPreviewSkillWindow.Controller.UIHeroPreviewSkillWindowCtrl"),
  View = require("UI.UILWHero.UIHeroPreviewSkillWindow.View.UIHeroPreviewSkillWindowView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroPreviewSkillWindow.prefab"
}
return {UIHeroPreviewSkillWindow = UIHeroPreviewSkillWindow}
