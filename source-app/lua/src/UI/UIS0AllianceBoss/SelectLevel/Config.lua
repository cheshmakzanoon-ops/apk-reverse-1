local UIS0AllianceBossSelect = {
  Name = UIWindowNames.UIS0AllianceBossSelect,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIS0AllianceBoss.SelectLevel.UIS0AllianceBossSelectCtrl"),
  View = require("UI.UIS0AllianceBoss.SelectLevel.UIS0AllianceBossSelectView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/S0AllianceBoss/UIS0AllianceBossSelectPopUp.prefab"
}
return {UIS0AllianceBossSelect = UIS0AllianceBossSelect}
