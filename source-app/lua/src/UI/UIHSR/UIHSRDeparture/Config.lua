local UIHSRDeparture = {
  Name = UIWindowNames.UIHSRDeparture,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHSR.UIHSRDeparture.UIHSRDepartureCtrl"),
  View = require("UI.UIHSR.UIHSRDeparture.UIHSRDepartureView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/HSR/UIHSRDeparture.prefab"
}
return {UIHSRDeparture = UIHSRDeparture}
