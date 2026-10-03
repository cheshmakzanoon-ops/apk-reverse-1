local UISubscriptionListPanel = {
  Name = UIWindowNames.UISubscriptionListPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISubscriptionListPanel.Controller.UISubscriptionListPanelCtrl"),
  View = require("UI.UISubscriptionListPanel.View.UISubscriptionListPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWGift/SubscriptionListPanel/UISubscriptionListPanel.prefab"
}
return {UISubscriptionListPanel = UISubscriptionListPanel}
