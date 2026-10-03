local UIDecorationShopDirectPurchase = {
  Name = UIWindowNames.UIDecorationShopDirectPurchase,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDecorationShopDirectPurchase.Controller.UIDecorationShopDirectPurchaseCtrl"),
  View = require("UI.UIDecorationShopDirectPurchase.View.UIDecorationShopDirectPurchaseView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIDecorationShopDirectPurchase/UIDecorationShopDirectPurchase.prefab"
}
return {UIDecorationShopDirectPurchase = UIDecorationShopDirectPurchase}
