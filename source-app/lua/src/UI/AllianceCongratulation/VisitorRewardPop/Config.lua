local LWAllianceThumbsUpPopView = {
  Name = UIWindowNames.LWAllianceThumbsUpPopView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.AllianceCongratulation.VisitorRewardPop.Ctrl.LWAllianceThumbsUpPopCtrl"),
  View = require("UI.AllianceCongratulation.VisitorRewardPop.View.LWAllianceThumbsUpPopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/AllianceCongratulation/LWAllianceThumbsUpPop.prefab"
}
return {LWAllianceThumbsUpPopView = LWAllianceThumbsUpPopView}
