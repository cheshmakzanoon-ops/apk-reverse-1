local UIStorageShopSelect = {
  Name = UIWindowNames.UIStorageShopSelect,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIStorageShopSelect.Controller.UIStorageShopSelectCtrl"),
  View = require("UI.UIStorageShopSelect.View.UIStorageShopSelectView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIStorageShop/UIStorageShopSelect.prefab"
}
return {UIStorageShopSelect = UIStorageShopSelect}
