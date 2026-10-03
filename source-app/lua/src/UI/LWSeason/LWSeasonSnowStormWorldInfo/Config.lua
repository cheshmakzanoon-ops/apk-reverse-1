local UIActSnowStormWorldInfo = {
  Name = UIWindowNames.UIActSnowStormWorldInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonSnowStormWorldInfo.Controller.UIActSnowStormWorldInfoCtrl"),
  View = require("UI.LWSeason.LWSeasonSnowStormWorldInfo.View.UIActSnowStormWorldInfo"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/SnowStormComing/UIActSnowStormWorldInfo.prefab"
}
return {UIActSnowStormWorldInfo = UIActSnowStormWorldInfo}
