local UIStorageShopRetrieveNew = {
  Name = UIWindowNames.UIStorageShopRetrieveNew,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIStorageShopRetrieveNew.Controller.UIStorageShopRetrieveNewCtrl"),
  View = require("UI.UIStorageShopRetrieveNew.View.UIStorageShopRetrieveNewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIStorageShop/UIStorageShopRetrieveNew.prefab"
}
return {UIStorageShopRetrieveNew = UIStorageShopRetrieveNew}
