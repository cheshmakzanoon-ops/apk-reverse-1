local UILWGrowFoundationBuy = {
  Name = UIWindowNames.UILWGrowFoundationBuy,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWGrowFoundationBuy.Controller.UILWGrowFoundationBuyCtrl"),
  View = require("UI.UILWGrowFoundationBuy.View.UILWGrowFoundationBuyView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWGift/GrowFoundation/UIGrowFoundationBuyPanel.prefab"
}
return {UILWGrowFoundationBuy = UILWGrowFoundationBuy}
