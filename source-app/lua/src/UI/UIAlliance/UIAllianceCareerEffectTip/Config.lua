local UIAllianceCareerEffectTip = {
  Name = UIWindowNames.UIAllianceCareerEffectTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceCareerEffectTip.Controller.UIAllianceCareerEffectTipCtrl"),
  View = require("UI.UIAlliance.UIAllianceCareerEffectTip.View.UIAllianceCareerEffectTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/AllianceCareer/UIAllianceCareerEffectTip.prefab"
}
return {UIAllianceCareerEffectTip = UIAllianceCareerEffectTip}
