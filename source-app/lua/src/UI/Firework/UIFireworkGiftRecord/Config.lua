local UIFireworkGiftRecord = {
  Name = UIWindowNames.UIFireworkGiftRecord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.Firework.UIFireworkGiftRecord.Controller.UIFireworkGiftRecordCtrl"),
  View = require("UI.Firework.UIFireworkGiftRecord.View.UIFireworkGiftRecordView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIFirework/UIFireworkBoxClaimInfoPanel.prefab"
}
return {UIFireworkGiftRecord = UIFireworkGiftRecord}
