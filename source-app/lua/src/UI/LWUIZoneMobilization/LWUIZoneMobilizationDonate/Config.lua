local LWUIMobilizationDonate = {
  Name = UIWindowNames.LWUIMobilizationDonate,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIZoneMobilization.LWUIZoneMobilizationDonate.Controller.LWUIMobilizationDonateCtrl"),
  View = require("UI.LWUIZoneMobilization.LWUIZoneMobilizationDonate.View.LWUIMobilizationDonateView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIZoneMobilization/LWUIZoneMobilizationDonate.prefab"
}
return {LWUIMobilizationDonate = LWUIMobilizationDonate}
