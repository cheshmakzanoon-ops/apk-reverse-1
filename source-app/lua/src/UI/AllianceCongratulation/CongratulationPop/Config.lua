local LWAllianceCongratulationPopView = {
  Name = UIWindowNames.LWAllianceCongratulationPopView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.AllianceCongratulation.CongratulationPop.Ctrl.LWAllianceCongratulationPopCtrl"),
  View = require("UI.AllianceCongratulation.CongratulationPop.View.LWAllianceCongratulationPopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/AllianceCongratulation/LWAllianceCongratulationPop.prefab"
}
return {LWAllianceCongratulationPopView = LWAllianceCongratulationPopView}
