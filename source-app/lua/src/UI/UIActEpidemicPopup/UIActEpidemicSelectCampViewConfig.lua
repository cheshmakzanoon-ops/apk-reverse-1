local UIActEpidemicSelectCampView = {
  Name = UIWindowNames.UIActEpidemicSelectCampView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActEpidemicPopup.Ctrl.UIActEpidemicSelectCampCtrl"),
  View = require("UI.UIActEpidemicPopup.View.UIActEpidemicSelectCampView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicSelectCampView.prefab"
}
return {UIActEpidemicSelectCampView = UIActEpidemicSelectCampView}
