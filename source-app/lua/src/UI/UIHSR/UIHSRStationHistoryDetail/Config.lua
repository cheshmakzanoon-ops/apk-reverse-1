local UIHSRStationHistoryDetail = {
  Name = UIWindowNames.UIHSRStationHistoryDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHSR.UIHSRStationHistoryDetail.UIHSRStationHistoryDetailCtrl"),
  View = require("UI.UIHSR.UIHSRStationHistoryDetail.UIHSRStationHistoryDetailView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/HSR/UIHSRStationHistoryDetail.prefab"
}
return {UIHSRStationHistoryDetail = UIHSRStationHistoryDetail}
