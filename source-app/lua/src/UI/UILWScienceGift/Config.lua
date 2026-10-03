local UILWScienceGift = {
  Name = UIWindowNames.UILWScienceGift,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWScienceGift.Controller.UILWScienceGiftCtrl"),
  View = require("UI.UILWScienceGift.View.UILWScienceGiftView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWScience/UILWScienceGift.prefab"
}
return {UILWScienceGift = UILWScienceGift}
