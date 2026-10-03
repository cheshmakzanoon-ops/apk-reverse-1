local UILWDominatorSkillDetail = {
  Name = UIWindowNames.UILWDominatorSkillDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI/UILWDominator/SkillDetail/Controller/UILWDominatorSkillDetailCtrl"),
  View = require("UI/UILWDominator/SkillDetail/View/UILWDominatorSkillDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorSkillDetail.prefab"
}
return {UILWDominatorSkillDetail = UILWDominatorSkillDetail}
