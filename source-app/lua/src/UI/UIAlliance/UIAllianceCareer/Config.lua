local UIAllianceCareerEdit = {
  Name = UIWindowNames.UIAllianceCareerEdit,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceCareer.Controller.UIAllianceCareerCtrl"),
  View = require("UI.UIAlliance.UIAllianceCareer.View.UIAllianceCareerEditView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/AllianceCareer/UIAllianceCareerEdit.prefab"
}
return {UIAllianceCareerEdit = UIAllianceCareerEdit}
