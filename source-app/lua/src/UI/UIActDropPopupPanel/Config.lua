local UIActDropPopupPanel = {
  Name = UIWindowNames.UIActDropPopupPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActDropPopupPanel.Controller.UIActDropPopupPanelCtrl"),
  View = require("UI.UIActDropPopupPanel.View.UIActDropPopupPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/SendGiftContent/UIActDropPopupPanel.prefab"
}
return {UIActDropPopupPanel = UIActDropPopupPanel}
