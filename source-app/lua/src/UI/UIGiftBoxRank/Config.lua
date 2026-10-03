local UIGiftBoxRank = {
  Name = UIWindowNames.UIGiftBoxRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGiftBoxRank.Controller.UIGiftBoxRankCtrl"),
  View = require("UI.UIGiftBoxRank.View.UIGiftBoxRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/GiftBox/UIGiftBoxRank.prefab"
}
return {UIGiftBoxRank = UIGiftBoxRank}
