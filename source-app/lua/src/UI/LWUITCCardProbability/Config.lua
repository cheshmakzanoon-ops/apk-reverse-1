local TCCardRecruitProbability = {
  Name = UIWindowNames.TCCardRecruitProbability,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUITCCardProbability.Ctrl.UITCCardRecruitProbabilityCtrl"),
  View = require("UI.LWUITCCardProbability.View.UITCCardRecruitProbabilityView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTCProbability/UITCCardRecruitProbability.prefab"
}
return {TCCardRecruitProbability = TCCardRecruitProbability}
