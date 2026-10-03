local UIActEpidemicAssignArbiterViewConfig = {
  Name = UIWindowNames.UIActEpidemicAssignArbiterView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActEpidemicPopup.Ctrl.UIActEpidemicAssignArbiterCtrl"),
  View = require("UI.UIActEpidemicPopup.View.UIActEpidemicAssignArbiterView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicAssignArbiterView.prefab"
}
return {UIActEpidemicAssignArbiterViewConfig = UIActEpidemicAssignArbiterViewConfig}
