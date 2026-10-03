local UIPVEShop = {
  Name = UIWindowNames.UIPVEShop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPVE.UIPVEShop.Controller.UIPVEShopCtrl"),
  View = require("UI.UIPVE.UIPVEShop.View.UIPVEShopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVEShop.prefab"
}
return {UIPVEShop = UIPVEShop}
