local LWUIGroupGiftDetail = {
  Name = UIWindowNames.LWUIGroupGiftDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWGiftSystem.GiftGroupDetail.Controller.LWUIGiftGroupDetailCtrl"),
  View = require("UI.LWPlayerInfo.UILWGiftSystem.GiftGroupDetail.View.LWUIGiftGroupDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/LWUIGiftGroupDetail.prefab"
}
return {LWUIGroupGiftDetail = LWUIGroupGiftDetail}
