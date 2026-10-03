local UIStorageShop = {
  Name = UIWindowNames.UIStorageShop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIStorageShop.Controller.UIStorageShopCtrl"),
  View = require("UI.UIStorageShop.View.UIStorageShopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIStorageShop/UIStorageShop.prefab"
}
return {UIStorageShop = UIStorageShop}
