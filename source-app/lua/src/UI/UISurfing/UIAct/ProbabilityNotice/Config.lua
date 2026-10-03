local UIProbabilityNoticeNew = {
  Name = UIWindowNames.UIProbabilityNoticeNew,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISurfing.UIAct.ProbabilityNotice.Ctrl.UIProbabilityNoticeNewCtrl"),
  View = require("UI.UISurfing.UIAct.ProbabilityNotice.View.UIProbabilityNoticeNewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SurfingBattle/UIProbabilityNoticeNew.prefab"
}
return {UIProbabilityNoticeNew = UIProbabilityNoticeNew}
