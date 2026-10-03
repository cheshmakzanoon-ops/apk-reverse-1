local UIActivityDecorationGachaWish = {
  Name = UIWindowNames.UIActivityDecorationGachaWish,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActivityDecorationGacha.Wish.Ctrl.ActivityDecorationGachaWishCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActivityDecorationGacha.Wish.View.ActivityDecorationGachaWishView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DecorationGacha/UIDecorationGachaWish.prefab"
}
return {UIActivityDecorationGachaWish = UIActivityDecorationGachaWish}
