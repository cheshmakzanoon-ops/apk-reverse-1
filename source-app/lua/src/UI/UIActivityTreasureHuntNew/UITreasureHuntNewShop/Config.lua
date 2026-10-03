local UITreasureHuntNewShop = {
  Name = UIWindowNames.UITreasureHuntNewShop,
  Layer = UILayer.Normal,
  Ctrl = require("UI/UIActivityTreasureHuntNew/UITreasureHuntNewShop/Controller/UITreasureHuntNewShopCtrl"),
  View = require("UI/UIActivityTreasureHuntNew/UITreasureHuntNewShop/View/UITreasureHuntNewShopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/TreasureHuntNew/UITreasureHuntNewShop.prefab"
}
return {UITreasureHuntNewShop = UITreasureHuntNewShop}
