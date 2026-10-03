local LWActivityArenaRecords = {
  Name = UIWindowNames.LWActivityArenaRecords,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWActivityArena.Records.LWActivityArenaRecordsCtrl"),
  View = require("UI.LWActivityArena.Records.LWActivityArenaRecordsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ArenaNewbie/UIActivityArenaRecords.prefab"
}
return {LWActivityArenaRecords = LWActivityArenaRecords}
