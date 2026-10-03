local UIVipPurchase = {
  Name = UIWindowNames.UIVipPurchase,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIVip.UIVipPurchase.Controller.UIVipPurchaseCtrl"),
  View = require("UI.UIVip.UIVipPurchase.View.UIVipPurchaseView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWVIPPanel/UIVipPurchases.prefab"
}
return {WorldDesUI = UIVipPurchase}
