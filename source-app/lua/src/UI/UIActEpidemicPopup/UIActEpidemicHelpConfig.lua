local UIActEpidemicHelpView = {
  Name = UIWindowNames.UIActEpidemicHelpView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActEpidemicPopup.Ctrl.UIActEpidemicHelpCtrl"),
  View = require("UI.UIActEpidemicPopup.View.UIActEpidemicHelpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicHelpView.prefab"
}
return {UIActEpidemicHelpView = UIActEpidemicHelpView}
