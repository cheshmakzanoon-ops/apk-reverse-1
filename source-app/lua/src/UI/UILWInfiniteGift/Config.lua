local UILWInfiniteGift = {
  Name = UIWindowNames.UILWInfiniteGift,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWInfiniteGift.Controller.UILWInfiniteGiftCtrl"),
  View = require("UI.UILWInfiniteGift.View.UILWInfiniteGiftView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIInfiniteGift/UILWInfiniteGift.prefab"
}
return {UILWInfiniteGift = UILWInfiniteGift}
