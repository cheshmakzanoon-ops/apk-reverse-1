local UIActBanquetDonate = {
  Name = UIWindowNames.UIActBanquetDonate,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActBanquetDonate.Controller.UIActBanquetDonateCtrl"),
  View = require("UI.UIActBanquetDonate.View.UIActBanquetDonateView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/ThanksGivingDonateView.prefab"
}
return {UIActBanquetDonate = UIActBanquetDonate}
