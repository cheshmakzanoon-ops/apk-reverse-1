local UIHSRPersonalHistoryList = {
  Name = UIWindowNames.UIHSRPersonalHistoryList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHSR.UIHSRPersonalHistoryList.UIHSRPersonalHistoryListCtrl"),
  View = require("UI.UIHSR.UIHSRPersonalHistoryList.UIHSRPersonalHistoryListView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/HSR/UIHSRPersonalHistoryList.prefab"
}
return {UIHSRPersonalHistoryList = UIHSRPersonalHistoryList}
