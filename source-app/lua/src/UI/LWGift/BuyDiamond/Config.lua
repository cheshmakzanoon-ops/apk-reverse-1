local UIMain = {
  Name = UIWindowNames.LWBuyDiamond,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWGift.BuyDiamond.Controller.LWBuyDiamondCtrl"),
  View = require("UI.LWGift.BuyDiamond.View.LWBuyDiamondView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWGift/BuyDiamondPanel.prefab",
  HideBack = true
}
return {UIMain = UIMain}
