local UIAllyDrillDonate = {
  Name = UIWindowNames.UIAllyDrillDonate,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllyDrill.UIAllyDrillDonate.Controller.UIAllyDrillDonateCtrl"),
  View = require("UI.UIAllyDrill.UIAllyDrillDonate.View.UIAllyDrillDonateView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/AllyDrill/UIAllyDrillDonate.prefab"
}
return {UIAllyDrillDonate = UIAllyDrillDonate}
