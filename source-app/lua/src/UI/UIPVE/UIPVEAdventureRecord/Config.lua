local UIPVEAdventureRecord = {
  Name = UIWindowNames.UIPVEAdventureRecord,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIPVE.UIPVEAdventureRecord.Controller.UIPVEAdventureRecordCtrl"),
  View = require("UI.UIPVE.UIPVEAdventureRecord.View.UIPVEAdventureRecordView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVEAdventureRecord.prefab"
}
return {UIPVEAdventureRecord = UIPVEAdventureRecord}
