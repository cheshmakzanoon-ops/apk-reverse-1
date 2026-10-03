local LWUIGiftAnimPanel = {
  Name = UIWindowNames.LWUIGiftAnimPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWGiftSystem.GiftAnimPanel.Ctrl.LWUIGiftAnimPanelCtrl"),
  View = require("UI.LWPlayerInfo.UILWGiftSystem.GiftAnimPanel.View.LWUIGiftAnimPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/LWUIGiftAnimPanel.prefab",
  CustomKeyCodeEscape = true
}
return {LWUIGiftAnimPanel = LWUIGiftAnimPanel}
