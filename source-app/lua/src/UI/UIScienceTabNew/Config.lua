local UIScienceTab = {
  Name = UIWindowNames.UIScienceTab,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIScienceTabNew.Controller.UIScienceTabNewCtrl"),
  View = require("UI.UIScienceTabNew.View.UIScienceTabNewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIScience/UIScienceTabMain.prefab"
}
return {UIScienceTab = UIScienceTab}
