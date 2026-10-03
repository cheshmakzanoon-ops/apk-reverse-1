local UIActEpidemicCampResultView = {
  Name = UIWindowNames.UIActEpidemicCampResultView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActEpidemicPopup.Ctrl.UIActEpidemicCampResultCtrl"),
  View = require("UI.UIActEpidemicPopup.View.UIActEpidemicCampResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicCampResultView.prefab"
}
return {UIActEpidemicCampResultView = UIActEpidemicCampResultView}
