local UIGroceryStore = {
  Name = UIWindowNames.UIGroceryStore,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIGroceryStore.Controller.UIGroceryStoreCtrl"),
  View = require("UI.UIGroceryStore.View.UIGroceryStoreView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGroceryStore/UIGroceryStore.prefab"
}
return {UIGroceryStore = UIGroceryStore}
