local UIS0AllianceBossBuild = {
  Name = UIWindowNames.UIS0AllianceBossBuild,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIS0AllianceBoss.Build.UIS0AllianceBossBuildCtrl"),
  View = require("UI.UIS0AllianceBoss.Build.UIS0AllianceBossBuildView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/S0AllianceBoss/UIS0AllianceBossBuildPopUp.prefab"
}
return {UIS0AllianceBossBuild = UIS0AllianceBossBuild}
