local UIBuyCredit = {
  Name = UIWindowNames.UIBuyCredit,
  Layer = UILayer.Info,
  Ctrl = require("UI.LWGift.BuyCredit.Controller.LWBuyCreditCtrl"),
  View = require("UI.LWGift.BuyCredit.View.LWBuyCreditView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWGift/BuyCredit/BuyCreditPanel.prefab"
}
return {UIBuyCredit = UIBuyCredit}
