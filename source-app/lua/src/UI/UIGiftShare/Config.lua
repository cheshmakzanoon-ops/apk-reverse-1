local UIGiftShare = {
  Name = UIWindowNames.UIGiftShare,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGiftShare.Controller.UIGiftShareCtrl"),
  View = require("UI.UIGiftShare.View.UIGiftShareView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIGiftShare.prefab"
}
return {UIGiftShare = UIGiftShare}
