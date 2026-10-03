local UIMain = {
  Name = UIWindowNames.LWBuyDiamondPop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWGift.BuyDiamondPop.Controller.LWBuyDiamondPopCtrl"),
  View = require("UI.LWGift.BuyDiamondPop.View.LWBuyDiamondPopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWGift/BuyDiamondPopPanel.prefab"
}
return {UIMain = UIMain}
