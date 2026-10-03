local UICampScienceDestroyRecord = {
  Name = UIWindowNames.UICampScienceDestroyRecord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeasonShared.UICampScienceDestroyRecord.Controller.UICampScienceDestroyRecordCtrl"),
  View = require("UI.LWSeasonShared.UICampScienceDestroyRecord.View.UICampScienceDestroyRecordView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/CampScience/UICampScienceDestroyRecord.prefab"
}
return {UICampScienceDestroyRecord = UICampScienceDestroyRecord}
