local UITreasureHuntShop = {
  Name = UIWindowNames.UITreasureHuntShop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UITreasureHuntShop.Controller.UITreasureHuntShopCtrl"),
  View = require("UI.UITreasureHuntShop.View.UITreasureHuntShopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/TreasureHunt/UITreasureHuntShop.prefab"
}
return {UITreasureHuntShop = UITreasureHuntShop}
