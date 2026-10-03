local UISunriseFoundationPopUpPanel = {
  Name = UIWindowNames.UISunriseFoundationPopUpPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISunriseFoundation.UISunriseFoundationPopUpPanel.Controller.UISunriseFoundationPopUpPanelCtrl"),
  View = require("UI.UISunriseFoundation.UISunriseFoundationPopUpPanel.View.UISunriseFoundationPopUpPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWGift/GrowFoundation/UISunriseFoundationPopUpPanel.prefab"
}
return {UISunriseFoundationPopUpPanel = UISunriseFoundationPopUpPanel}
