local UIAllianceOfficeSelect = {
  Name = UIWindowNames.UIAllianceOfficeSelect,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceOfficeSelect.Controller.UIAllianceOfficeSelectCtrl"),
  View = require("UI.UIAlliance.UIAllianceOfficeSelect.View.UIAllianceOfficeSelectView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceOfficeSelect.prefab"
}
return {UIAllianceOfficeSelect = UIAllianceOfficeSelect}
