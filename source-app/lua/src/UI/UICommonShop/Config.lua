local UICommonShop = {
  Name = UIWindowNames.UICommonShop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICommonShop.Controller.UICommonShopCtrl"),
  View = require("UI.UICommonShop.View.UICommonShopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICommonShop/UICommonShop.prefab"
}
return {UICommonShop = UICommonShop}
