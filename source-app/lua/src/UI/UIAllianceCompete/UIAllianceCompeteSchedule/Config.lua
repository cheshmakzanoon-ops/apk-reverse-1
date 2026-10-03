local UIAllianceCompeteSchedule = {
  Name = UIWindowNames.UIAllianceCompeteSchedule,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllianceCompete.UIAllianceCompeteSchedule.Controller.UIAllianceCompeteScheduleCtrl"),
  View = require("UI.UIAllianceCompete.UIAllianceCompeteSchedule.View.UIAllianceCompeteScheduleView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllianceCompeteNew/UIAllianceCompeteSchedule.prefab"
}
return {UIAllianceCompeteSchedule = UIAllianceCompeteSchedule}
