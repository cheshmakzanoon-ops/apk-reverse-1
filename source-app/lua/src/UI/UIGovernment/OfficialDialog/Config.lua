local UIGovernmentOfficialDialog = {
  Name = UIWindowNames.UIGovernmentOfficialDialog,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.OfficialDialog.Controller.OfficialDialogCtrl"),
  View = require("UI.UIGovernment.OfficialDialog.View.OfficialDialogView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/OfficialDialog.prefab"
}
return {UIGovernmentOfficialDialog = UIGovernmentOfficialDialog}
