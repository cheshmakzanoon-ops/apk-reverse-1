local UIHSRStationHistorySimpleList = {
  Name = UIWindowNames.UIHSRStationHistorySimpleList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHSR.UIHSRStationHistorySimpleList.UIHSRStationHistorySimpleListCtrl"),
  View = require("UI.UIHSR.UIHSRStationHistorySimpleList.UIHSRStationHistorySimpleListView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/HSR/UIHSRStationHistorySimpleList.prefab"
}
return {UIHSRStationHistorySimpleList = UIHSRStationHistorySimpleList}
