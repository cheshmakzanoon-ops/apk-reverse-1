local UIStorageShopMain = {
  Name = UIWindowNames.UIStorageShop,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIStorageShopMain.Controller.UIStorageShopMainCtrl"),
  View = require("UI.UIStorageShopMain.View.UIStorageShopMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIStorageShop/UIStorageShopMain.prefab"
}
return {UIStorageShopMain = UIStorageShopMain}
