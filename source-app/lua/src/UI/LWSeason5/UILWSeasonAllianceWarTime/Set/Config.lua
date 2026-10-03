local SeasonAllianceWarTimeSetView = {
  Name = UIWindowNames.SeasonAllianceWarTimeSetView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.UILWSeasonAllianceWarTime.Set.Ctrl.SeasonAllianceWarTimeSetCtrl"),
  View = require("UI.LWSeason5.UILWSeasonAllianceWarTime.Set.View.SeasonAllianceWarTimeSetView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/AllianceWarTime/SeasonAllianceWarTimeSet.prefab"
}
return {SeasonAllianceWarTimeSetView = SeasonAllianceWarTimeSetView}
