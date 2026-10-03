local GiftEffectPreview = {
  Name = UIWindowNames.GiftEffectPreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWGiftSystem.GiftEffectPreview.Controller.UIGiftEffectPreviewWindowCtrl"),
  View = require("UI.LWPlayerInfo.UILWGiftSystem.GiftEffectPreview.View.UIGiftEffectPreviewWindowView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/UIGiftEffectPreviewWindow.prefab"
}
return {GiftEffectPreview = GiftEffectPreview}
