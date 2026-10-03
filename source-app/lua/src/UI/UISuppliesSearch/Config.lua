local UISuppliesSearch = {
  Name = UIWindowNames.UISuppliesSearch,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISuppliesSearch.Ctrl.UISuppliesSearchCtrl"),
  View = require("UI.UISuppliesSearch.View.UISuppliesSearchView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SuppliesSearch/UISuppliesSearch.prefab"
}
return {UISuppliesSearch = UISuppliesSearch}
