local UIActGiftBoxOpen = {
  Name = UIWindowNames.UIActGiftBoxOpen,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActGiftBox.UIActGiftBoxOpen.Controller.UIActGiftBoxOpenCtrl"),
  View = require("UI.UIActGiftBox.UIActGiftBoxOpen.View.UIActGiftBoxOpenView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/GiftBox/UIActGiftBoxOpen.prefab"
}
return {UIActGiftBoxOpen = UIActGiftBoxOpen}
