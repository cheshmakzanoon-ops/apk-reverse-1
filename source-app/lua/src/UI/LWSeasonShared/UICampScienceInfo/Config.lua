local UICampScienceInfo = {
  Name = UIWindowNames.UICampScienceInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeasonShared.UICampScienceInfo.Controller.UICampScienceInfoCtrl"),
  View = require("UI.LWSeasonShared.UICampScienceInfo.View.UICampScienceInfoView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/CampScience/UICampScienceInfo.prefab"
}
return {UICampScienceInfo = UICampScienceInfo}
