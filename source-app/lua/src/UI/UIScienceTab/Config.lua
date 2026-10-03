local UIScienceTab = {
  Name = UIWindowNames.UIScienceTab,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIScienceTab.Controller.UIScienceTabCtrl"),
  View = require("UI.UIScienceTab.View.UIScienceTabView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIScience/UIScienceTab.prefab"
}
return {UIScienceTab = UIScienceTab}
