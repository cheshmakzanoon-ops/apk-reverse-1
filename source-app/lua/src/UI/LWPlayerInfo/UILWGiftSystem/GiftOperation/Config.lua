local LWUIGiftOperation = {
  Name = UIWindowNames.LWUIGiftOperation,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWGiftSystem.GiftOperation.Controller.LWUIGiftOperationCtrl"),
  View = require("UI.LWPlayerInfo.UILWGiftSystem.GiftOperation.View.LWUIGiftOperationView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/LWUIGiftOperation.prefab"
}
return {LWUIGiftOperation = LWUIGiftOperation}
