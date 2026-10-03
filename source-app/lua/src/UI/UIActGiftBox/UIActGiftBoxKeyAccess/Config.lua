local UIActGiftBoxKeyAccess = {
  Name = UIWindowNames.UICommonAccessBigPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActGiftBox.UIActGiftBoxKeyAccess.Controller.UIActGiftBoxKeyAccessCtrl"),
  View = require("UI.UIActGiftBox.UIActGiftBoxKeyAccess.View.UIActGiftBoxKeyAccessView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/GiftBox/GiftBoxKeyAccessPanel.prefab"
}
return {UIActGiftBoxKeyAccess = UIActGiftBoxKeyAccess}
