local LWUIGiftSetMsgShowPanel = {
  Name = UIWindowNames.LWUIGiftSetMsgShowPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWGiftSystem.LWUIGiftSetMsgShowPanel.Controller.LWUIGiftSetMsgShowPanelCtrl"),
  View = require("UI.LWPlayerInfo.UILWGiftSystem.LWUIGiftSetMsgShowPanel.View.LWUIGiftSetMsgShowPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/LWUIGiftSetMsgShowPanel.prefab"
}
return {LWUIGiftSetMsgShowPanel = LWUIGiftSetMsgShowPanel}
