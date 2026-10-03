local BuyDiamondPackTips = {
  Name = UIWindowNames.BuyDiamondPackTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWGift.BuyDiamondPackTips.Controller.BuyDiamondPackTipsCtrl"),
  View = require("UI.LWGift.BuyDiamondPackTips.View.BuyDiamondPackTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWGift/BuyDiamondPackTips.prefab"
}
return {BuyDiamondPackTips = BuyDiamondPackTips}
