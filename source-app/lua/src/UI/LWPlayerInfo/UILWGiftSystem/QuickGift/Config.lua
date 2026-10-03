local LWUIQuickGift = {
  Name = UIWindowNames.LWUIQuickGift,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWGiftSystem.QuickGift.Ctrl.LWUIQuickGiftCtrl"),
  View = require("UI.LWPlayerInfo.UILWGiftSystem.QuickGift.View.LWUIQuickGiftView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/LWUIQuickGift.prefab"
}
return {LWUIQuickGift = LWUIQuickGift}
