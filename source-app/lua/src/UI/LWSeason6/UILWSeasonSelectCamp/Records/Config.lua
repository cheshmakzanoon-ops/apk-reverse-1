local S6SelectCampRecordsView = {
  Name = UIWindowNames.S6SelectCampRecordsView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.UILWSeasonSelectCamp.Records.Ctrl.S6SelectCampRecordsCtrl"),
  View = require("UI.LWSeason6.UILWSeasonSelectCamp.Records.View.S6SelectCampRecordsView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/SelectCamp/S6SelectCampRecords.prefab"
}
return {S6SelectCampRecordsView = S6SelectCampRecordsView}
