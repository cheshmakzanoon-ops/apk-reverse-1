local LWUIZoneMobilizationRankRewardPreview = {
  Name = UIWindowNames.LWUIZoneMobilizationRankRewardPreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIZoneMobilization.LWUIRankRewardPreview.Controller.LWUIZoneMobilizationRankRewardPreviewCtrl"),
  View = require("UI.LWUIZoneMobilization.LWUIRankRewardPreview.View.LWUIZoneMobilizationRankRewardPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIZoneMobilization/LWUIZoneMobilizationRankRewardPreviewPanel.prefab"
}
return {LWUIZoneMobilizationRankRewardPreview = LWUIZoneMobilizationRankRewardPreview}
