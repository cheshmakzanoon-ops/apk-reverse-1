local UIStorageShopHistory = {
  Name = UIWindowNames.UIStorageShopHistory,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIStorageShopHistory.Controller.UIStorageShopHistoryCtrl"),
  View = require("UI.UIStorageShopHistory.View.UIStorageShopHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIStorageShop/UIStorageShopHistory.prefab"
}
return {UIStorageShopHistory = UIStorageShopHistory}
