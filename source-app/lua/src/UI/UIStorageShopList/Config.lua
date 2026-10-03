local UIStorageShopList = {
  Name = UIWindowNames.UIStorageShopList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIStorageShopList.Controller.UIStorageShopListCtrl"),
  View = require("UI.UIStorageShopList.View.UIStorageShopListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIStorageShop/UIStorageShopList.prefab"
}
return {UIStorageShopList = UIStorageShopList}
