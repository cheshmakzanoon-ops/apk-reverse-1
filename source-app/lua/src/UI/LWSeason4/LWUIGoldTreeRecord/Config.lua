local LWUIGoldTreeRecord = {
  Name = UIWindowNames.LWUIGoldTreeRecord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason4/LWUIGoldTreeRecord.Controller.LWUIGoldTreeRecordCtrl"),
  View = require("UI.LWSeason4/LWUIGoldTreeRecord.View.LWUIGoldTreeRecordView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/GoldTreeThird/LWUIGoldTreeRecord.prefab",
  HideBack = false,
  CustomKeyCodeEscape = true
}
return {LWUIGoldTreeRecord = LWUIGoldTreeRecord}
