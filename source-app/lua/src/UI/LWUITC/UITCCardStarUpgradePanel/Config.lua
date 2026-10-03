local UITCCardStarUpgradePanel = {
  Name = UIWindowNames.UITCCardStarUpgradePanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUITC.UITCCardStarUpgradePanel.Ctrl.UITCCardStarUpgradePanelCtrl"),
  View = require("UI.LWUITC.UITCCardStarUpgradePanel.View.UITCCardStarUpgradePanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/UITCCardStarUpgradePanel.prefab"
}
return {UITCCardStarUpgradePanel = UITCCardStarUpgradePanel}
