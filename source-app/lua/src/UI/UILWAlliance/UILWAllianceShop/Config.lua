local UILWAllianceShop = {
  Name = UIWindowNames.UILWAllianceShop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAllianceShop.Controller.UILWAllianceShopCtrl"),
  View = require("UI.UILWAlliance.UILWAllianceShop.View.UILWAllianceShopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAllianceShop.prefab"
}
return {UILWAllianceShop = UILWAllianceShop}
