local UIBargainShopRules = {
  Name = UIWindowNames.UIBargainShopRules,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.UIBargainShop.UIBargainShopRules.Ctrl.UIBargainShopRulesCtrl"),
  View = require("UI.UIActivityCenterTable.Component.UIBargainShop.UIBargainShopRules.View.UIBargainShopRulesView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/BargainShop/Rules/UIBargainShopRules.prefab"
}
return {UIBargainShopRules = UIBargainShopRules}
