local LWUIGiftHistory = {
  Name = UIWindowNames.LWUIGiftHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWGiftSystem.GiftHistory.Controller.LWUIGiftHistoryCtrl"),
  View = require("UI.LWPlayerInfo.UILWGiftSystem.GiftHistory.View.LWUIGiftHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/LWUIGiftHistory.prefab"
}
return {LWUIGiftHistory = LWUIGiftHistory}
