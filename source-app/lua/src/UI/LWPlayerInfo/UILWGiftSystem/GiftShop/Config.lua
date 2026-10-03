local LWUIGiftShop = {
  Name = UIWindowNames.LWUIGiftShop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWGiftSystem.GiftShop.Ctrl.LWUIGiftShopCtrl"),
  View = require("UI.LWPlayerInfo.UILWGiftSystem.GiftShop.View.LWUIGiftShopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/LWUIGiftShop.prefab"
}
return {LWUIGiftShop = LWUIGiftShop}
