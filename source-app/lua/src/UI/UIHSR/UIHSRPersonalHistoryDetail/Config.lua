local UIHSRPersonalHistoryDetail = {
  Name = UIWindowNames.UIHSRPersonalHistoryDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHSR.UIHSRPersonalHistoryDetail.UIHSRPersonalHistoryDetailCtrl"),
  View = require("UI.UIHSR.UIHSRPersonalHistoryDetail.UIHSRPersonalHistoryDetailView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/HSR/UIHSRPersonalHistoryDetail.prefab"
}
return {UIHSRPersonalHistoryDetail = UIHSRPersonalHistoryDetail}
