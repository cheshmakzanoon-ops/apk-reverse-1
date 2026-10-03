local UIServerMaintenanceTip = {
  Name = UIWindowNames.UIServerMaintenanceTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIServerMaintenanceTip.Controller.UIServerMaintenanceTipCtrl"),
  View = require("UI.UIServerMaintenanceTip.View.UIServerMaintenanceTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UIServerMaintenanceTip.prefab"
}
return {UIServerMaintenanceTip = UIServerMaintenanceTip}
