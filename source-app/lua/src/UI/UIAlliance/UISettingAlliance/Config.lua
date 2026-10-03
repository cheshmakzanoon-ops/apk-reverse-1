local UISettingAlliance = {
  Name = UIWindowNames.UISettingAlliance,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UISettingAlliance.Controller.UISettingAllianceCtrl"),
  View = require("UI.UIAlliance.UISettingAlliance.View.UISettingAllianceView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UISettingAlliance.prefab"
}
return {UISettingAlliance = UISettingAlliance}
