local UILWVIPRadarPanel = {
  Name = UIWindowNames.UILWVIPRadarPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWVIPRadar.Main.Ctrl.UILWVIPRadarPanelCtrl"),
  View = require("UI.UILWVIPRadar.Main.View.UILWVIPRadarPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWVIPPanel/UILWVipRadar/UILWVIPRadarPanel.prefab"
}
return {UILWVIPRadarPanel = UILWVIPRadarPanel}
