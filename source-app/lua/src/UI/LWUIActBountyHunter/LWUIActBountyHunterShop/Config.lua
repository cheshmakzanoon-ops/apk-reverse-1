local LWUIActBountyHunterShop = {
  Name = UIWindowNames.LWUIActBountyHunterShop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActBountyHunter.LWUIActBountyHunterShop.Ctrl.LWUIActBountyHunterShopCtrl"),
  View = require("UI.LWUIActBountyHunter.LWUIActBountyHunterShop.View.LWUIActBountyHunterShopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterShop/BountyHunterShop.prefab"
}
return {LWUIActBountyHunterShop = LWUIActBountyHunterShop}
