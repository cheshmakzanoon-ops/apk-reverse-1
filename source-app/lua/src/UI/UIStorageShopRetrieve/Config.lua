local UIStorageShopRetrieve = {
  Name = UIWindowNames.UIStorageShopRetrieve,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIStorageShopRetrieve.Controller.UIStorageShopRetrieveCtrl"),
  View = require("UI.UIStorageShopRetrieve.View.UIStorageShopRetrieveView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIStorageShop/UIStorageShopRetrieve.prefab"
}
return {UIStorageShopRetrieve = UIStorageShopRetrieve}
