local UITCCardChoiceBoxTips = {
  Name = UIWindowNames.UITCCardChoiceBoxTips,
  Layer = UILayer.Info,
  Ctrl = require("UI/LWUITC/UITCCardChoiceBoxTips/Controller/UITCCardChoiceBoxTipsCtrl"),
  View = require("UI/LWUITC/UITCCardChoiceBoxTips/View/UITCCardChoiceBoxTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/UITCCardChoiceBoxTips.prefab"
}
return {UITCCardChoiceBoxTips = UITCCardChoiceBoxTips}
