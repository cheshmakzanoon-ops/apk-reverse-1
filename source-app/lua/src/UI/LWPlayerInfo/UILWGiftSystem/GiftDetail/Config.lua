local LWUIGiftDetail = {
  Name = UIWindowNames.LWUIGiftDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWGiftSystem.GiftDetail.Controller.LWUIGiftDetailCtrl"),
  View = require("UI.LWPlayerInfo.UILWGiftSystem.GiftDetail.View.LWUIGiftDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/LWUIGiftDetail.prefab"
}
return {LWUIGiftDetail = LWUIGiftDetail}
