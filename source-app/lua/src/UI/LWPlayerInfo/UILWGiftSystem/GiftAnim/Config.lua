local LWUIGiftSpecialAnimShow = {
  Name = UIWindowNames.LWUIGiftSpecialAnimShow,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWGiftSystem.GiftAnim.Controller.LWUIGiftSpecialAnimShowCtrl"),
  View = require("UI.LWPlayerInfo.UILWGiftSystem.GiftAnim.View.LWUIGiftSpecialAnimShowView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/LWUIGiftSpecialAnimShow.prefab",
  CustomKeyCodeEscape = true
}
return {LWUIGiftSpecialAnimShow = LWUIGiftSpecialAnimShow}
