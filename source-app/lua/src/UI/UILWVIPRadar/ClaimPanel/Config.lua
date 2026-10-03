local UILWVIPRadarClaimPanel = {
  Name = UIWindowNames.UILWVIPRadarClaimPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWVIPRadar.ClaimPanel.Ctrl.UILWVIPRadarClaimPanelCtrl"),
  View = require("UI.UILWVIPRadar.ClaimPanel.View.UILWVIPRadarClaimPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWVIPPanel/UILWVipRadar/UILWVIPRadarClaimPanel.prefab"
}
return {UILWVIPRadarClaimPanel = UILWVIPRadarClaimPanel}
