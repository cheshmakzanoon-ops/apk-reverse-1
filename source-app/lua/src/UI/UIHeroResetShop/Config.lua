local UIHeroResetShop = {
  Name = UIWindowNames.UIHeroResetShop,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIHeroResetShop.Controller.UIHeroResetShopCtrl"),
  View = require("UI.UIHeroResetShop.View.UIHeroResetShopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHeroResetShop/UIHeroResetShop.prefab"
}
return {UICommonShop = UIHeroResetShop}
