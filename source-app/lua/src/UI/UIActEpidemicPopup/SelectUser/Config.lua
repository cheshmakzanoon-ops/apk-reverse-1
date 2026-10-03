local UIActEpidemicSelectUserViewV2 = {
  Name = UIWindowNames.UIActEpidemicSelectUserViewV2,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActEpidemicPopup.SelectUser.Ctrl.UIBFEpidemicActSelectUserCtrl"),
  View = require("UI.UIActEpidemicPopup.SelectUser.View.UIBFEpidemicActSelectUserView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIBFEpidemicSelectUserV2.prefab"
}
return {UIActEpidemicSelectUserViewV2 = UIActEpidemicSelectUserViewV2}
