local UIMainMailTipsPanel = {
  Name = UIWindowNames.UIMainMailTipsPanel,
  Layer = UILayer.UIResource,
  Ctrl = require("UI.UIMainMailTipsPanel.Controller.UIMainMailTipsPanelCtrl"),
  View = require("UI.UIMainMailTipsPanel.View.UIMainMailTipsPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMain/UIMainMailTipsPanel.prefab"
}
return {UIMainMailTipsPanel = UIMainMailTipsPanel}
