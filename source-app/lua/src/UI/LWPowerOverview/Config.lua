local UILWResourceLack = {
  Name = UIWindowNames.LWPowerOverview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPowerOverview.Controller.LWPowerOverviewCtrl"),
  View = require("UI.LWPowerOverview.View.LWPowerOverviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPowerOverview/LWPowerOverview.prefab"
}
return {UILWResourceLack = UILWResourceLack}
