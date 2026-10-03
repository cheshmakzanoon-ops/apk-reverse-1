local NewPeakArenaRecord = {
  Name = UIWindowNames.NewPeakArenaRecord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.NewPeakArenaRecord.Controller.NewPeakArenaRecordCtrl"),
  View = require("UI.NewPeakArenaRecord.View.NewPeakArenaRecordView"),
  PrefabPath = "Assets/Main/Prefabs/NewPeakArena/NewPeakArenaRecord.prefab"
}
return {NewPeakArenaRecord = NewPeakArenaRecord}
