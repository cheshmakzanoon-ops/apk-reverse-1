local UIHeroRecruitPreview = {
  Name = UIWindowNames.UIHeroRecruitPreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UIHeroRecruitPreview.Ctrl.UIHeroRecruitPreviewCtrl"),
  View = require("UI.UIHero2.UIHeroRecruitPreview.View.UIHeroRecruitPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroRecruitPreview.prefab"
}
return {UIHeroRecruitPreview = UIHeroRecruitPreview}
