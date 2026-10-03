local UIS0AllianceBossRewardPreview = {
  Name = UIWindowNames.UIS0AllianceBossRewardPreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIS0AllianceBoss.RewardPreview.UIS0AllianceBossRewardPreviewCtrl"),
  View = require("UI.UIS0AllianceBoss.RewardPreview.UIS0AllianceBossRewardPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/S0AllianceBoss/UIS0AllianceBossRewardPreviewPopUp.prefab"
}
return {UIS0AllianceBossRewardPreview = UIS0AllianceBossRewardPreview}
