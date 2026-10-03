local UIAllianceShop = {
  Name = UIWindowNames.UIAllianceShop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceShop.Controller.UIAllianceShopCtrl"),
  View = require("UI.UIAlliance.UIAllianceShop.View.UIAllianceShopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceShop.prefab"
}
return {UIAllianceShop = UIAllianceShop}
