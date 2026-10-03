local UIActGiftGivingDropPanel = {
  Name = UIWindowNames.UIActGiftGivingDropPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActGiftGiving.UIActGiftGivingDropPanel.Controller.UIActGiftGivingDropPanelCtrl"),
  View = require("UI.UIActGiftGiving.UIActGiftGivingDropPanel.View.UIActGiftGivingDropPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActGiftGiving/UIActGiftGivingDropPanel.prefab"
}
return {UIActGiftGivingDropPanel = UIActGiftGivingDropPanel}
