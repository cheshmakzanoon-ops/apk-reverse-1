local UISettingCustomerService = {
  Name = UIWindowNames.UISettingCustomerService,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISetting.UISettingCustomerService.Controller.UISettingCustomerServiceCtrl"),
  View = require("UI.UISetting.UISettingCustomerService.View.UISettingCustomerServiceView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UISettingCustomerService.prefab"
}
return {UISettingCustomerService = UISettingCustomerService}
