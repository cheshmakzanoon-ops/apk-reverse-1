local UITrainBattleRecord = {
  Name = UIWindowNames.UITrainBattleRecord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UITrainBattleRecord.Controller.UITrainBattleRecordCtrl"),
  View = require("UI.UILWRailway.UITrainBattleRecord.View.UITrainBattleRecordView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/UITrainBattleRecord.prefab"
}
return {UITrainBattleRecord = UITrainBattleRecord}
