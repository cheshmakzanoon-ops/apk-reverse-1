local LWUIGiftDetail = {
  Name = UIWindowNames.LWUIGiftDetail_v2,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWGiftSystem.GiftDetail_v2.Controller.LWUIGiftDetailCtrl"),
  View = require("UI.LWPlayerInfo.UILWGiftSystem.GiftDetail_v2.View.LWUIGiftDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/LWUIGiftDetail_v2.prefab"
}
return {LWUIGiftDetail = LWUIGiftDetail}
