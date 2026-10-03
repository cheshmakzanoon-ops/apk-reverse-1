local UIAllianceKirovPlanTime = {
  Name = UIWindowNames.UIAllianceKirovPlanTime,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.KillZombie.AllianceKirovPlanTime.Controller.UIAllianceKirovPlanTimeCtrl"),
  View = require("UI.UIActivityCenterTable.Component.KillZombie.AllianceKirovPlanTime.View.UIAllianceKirovPlanTimeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/KillZombie/UIAllianceKirovPlanTime.prefab"
}
return {UIAllianceKirovPlanTime = UIAllianceKirovPlanTime}
