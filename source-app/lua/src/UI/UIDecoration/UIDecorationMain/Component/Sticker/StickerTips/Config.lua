local UIStickerTipsViewView = {
  Name = UIWindowNames.UIStickerTipsViewView,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIDecoration.UIDecorationMain.Component.Sticker.StickerTips.Ctrl.UIStickerTipsViewCtrl"),
  View = require("UI.UIDecoration.UIDecorationMain.Component.Sticker.StickerTips.View.UIStickerTipsViewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UIStickerTipsView.prefab"
}
return {UIStickerTipsViewView = UIStickerTipsViewView}
