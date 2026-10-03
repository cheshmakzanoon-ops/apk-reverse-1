local UISetAlOfficialPos = {
  Name = UIWindowNames.UISetAlOfficialPos,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UISetAlOfficialPos.Controller.UISetAlOfficialPosCtrl"),
  View = require("UI.UIAlliance.UISetAlOfficialPos.View.UISetAlOfficialPosView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/AlliancePosition/UISetAlOfficialPos.prefab"
}
return {UISetAlOfficialPos = UISetAlOfficialPos}
