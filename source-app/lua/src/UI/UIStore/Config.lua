local UIStore = {
  Name = UIWindowNames.UIStore,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIStore.Controller.UIStoreCtrl"),
  View = require("UI.UIStore.View.UIStoreView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIStore/UIStore.prefab"
}
return {UIStore = UIStore}
