local ValentineSendGiftRecord = {
  Name = UIWindowNames.ValentineSendGiftRecord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActValentineSendGiftRecord.Ctrl.LWUIActValentineSendGiftRecordCtrl"),
  View = require("UI.LWUIActValentineSendGiftRecord.View.LWUIActValentineSendGiftRecordView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/SendGiftContent/ActValentineSendGiftRecord.prefab"
}
return {ValentineSendGiftRecord = ValentineSendGiftRecord}
