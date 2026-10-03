local ValentineReceiveGiftRecord = {
  Name = UIWindowNames.ValentineReceiveGiftRecord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActValentineReceiveGiftRecord.Ctrl.LWUIActValentineReceiveGiftRecordCtrl"),
  View = require("UI.LWUIActValentineReceiveGiftRecord.View.LWUIActValentineReceiveGiftRecordView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/SendGiftContent/ActValentineReceiveGiftRecord.prefab"
}
return {ValentineReceiveGiftRecord = ValentineReceiveGiftRecord}
