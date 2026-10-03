local UISearch = {
  Name = UIWindowNames.UISearch,
  Layer = UILayer.Background,
  Ctrl = require("UI.UISearch.Controller.UISearchCtrl"),
  View = require("UI.UISearch.View.UISearchView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISearch/UISearch.prefab"
}
return {UISearch = UISearch}
