local UILWAllianceGift = {
  Name = UIWindowNames.UILWAllianceGift,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAllianceGift.Controller.UILWAllianceGiftCtrl"),
  View = require("UI.UILWAlliance.UILWAllianceGift.View.UILWAllianceGiftView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAllianceGift.prefab"
}
return {UILWAllianceGift = UILWAllianceGift}
