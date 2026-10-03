local LWUIZoneMobilizationBoxRewardPreview = {
  Name = UIWindowNames.LWUIZoneMobilizationBoxRewardPreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIZoneMobilization.LWUIBoxRewardPreview.Controller.LWUIZoneMobilizationBoxRewardPreviewCtrl"),
  View = require("UI.LWUIZoneMobilization.LWUIBoxRewardPreview.View.LWUIZoneMobilizationBoxRewardPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIZoneMobilization/LWUIZoneMobilizationBoxRewardPreviewPanel.prefab"
}
return {LWUIZoneMobilizationBoxRewardPreview = LWUIZoneMobilizationBoxRewardPreview}
