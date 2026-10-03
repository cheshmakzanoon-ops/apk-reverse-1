local UIAllianceGift = {
  Name = UIWindowNames.UIAllianceGift,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceGift.Controller.UIAllianceGiftCtrl"),
  View = require("UI.UIAlliance.UIAllianceGift.View.UIAllianceGiftView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceGift.prefab"
}
return {UIAllianceGift = UIAllianceGift}
