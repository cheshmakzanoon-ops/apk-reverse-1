local UILuckyRollShop = {
  Name = UIWindowNames.UILuckyRollShop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILuckyRollShop.Controller.UILuckyRollShopCtrl"),
  View = require("UI.UILuckyRollShop.View.UILuckyRollShopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/LuckyRoll/UILuckyRollShop.prefab"
}
return {UILuckyRollShop = UILuckyRollShop}
