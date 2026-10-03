local UIGiftBoxOpenRewardGet = {
  Name = UIWindowNames.UIGiftBoxOpenRewardGet,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGiftBoxOpenRewardGet.Controller.UIGiftBoxOpenRewardGetCtrl"),
  View = require("UI.UIGiftBoxOpenRewardGet.View.UIGiftBoxOpenRewardGetView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/GiftBox/UIGiftBoxOpenRewardGet.prefab"
}
return {UIGiftBoxOpenRewardGet = UIGiftBoxOpenRewardGet}
