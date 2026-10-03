local LWUIGiftShowDetailInfo = {
  Name = UIWindowNames.LWUIGiftShowDetailInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWGiftSystem.LWUIGiftShowDetailInfo.Controller.LWUIGiftShowDetailInfoCtrl"),
  View = require("UI.LWPlayerInfo.UILWGiftSystem.LWUIGiftShowDetailInfo.View.LWUIGiftShowDetailInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/LWUIGiftShowDetailInfo.prefab"
}
return {LWUIGiftShowDetailInfo = LWUIGiftShowDetailInfo}
