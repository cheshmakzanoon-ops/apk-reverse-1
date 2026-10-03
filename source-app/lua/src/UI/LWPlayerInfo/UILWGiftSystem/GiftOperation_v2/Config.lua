local LWUIGiftOperation = {
  Name = UIWindowNames.LWUIGiftOperation_v2,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWGiftSystem.GiftOperation_v2.Controller.LWUIGiftOperationCtrl"),
  View = require("UI.LWPlayerInfo.UILWGiftSystem.GiftOperation_v2.View.LWUIGiftOperationView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/LWUIGiftOperation_v2.prefab"
}
return {LWUIGiftOperation = LWUIGiftOperation}
