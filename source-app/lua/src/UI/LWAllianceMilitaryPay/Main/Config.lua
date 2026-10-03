local LWAllianceMilitaryPayMainView = {
  Name = UIWindowNames.LWAllianceMilitaryPayMainView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWAllianceMilitaryPay.Main.Ctrl.LWAllianceMilitaryPayMainCtrl"),
  View = require("UI.LWAllianceMilitaryPay.Main.View.LWAllianceMilitaryPayMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/AllianceMilitaryPay/LWAllianceMilitaryPayMain.prefab"
}
return {LWAllianceMilitaryPayMainView = LWAllianceMilitaryPayMainView}
