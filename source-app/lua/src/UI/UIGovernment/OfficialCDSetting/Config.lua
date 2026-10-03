local OfficialCDSetting = {
  Name = UIWindowNames.OfficialCDSetting,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.OfficialCDSetting.Controller.OfficialCDSettingCtrl"),
  View = require("UI.UIGovernment.OfficialCDSetting.View.OfficialCDSettingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/OfficialCDSetting.prefab"
}
return {OfficialCDSetting = OfficialCDSetting}
