local UILWDominatorUnlockSkillPreview = {
  Name = UIWindowNames.UILWDominatorUnlockSkillPreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI/UILWDominator/UnlockSkillPreview/Controller/UILWDominatorUnlockSkillPreviewCtrl"),
  View = require("UI/UILWDominator/UnlockSkillPreview/View/UILWDominatorUnlockSkillPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorMainUnlockSkillPreview.prefab"
}
return {UILWDominatorUnlockSkillPreview = UILWDominatorUnlockSkillPreview}
