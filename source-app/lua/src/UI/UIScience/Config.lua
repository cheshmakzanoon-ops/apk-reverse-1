local UIScience = {
  Name = UIWindowNames.UIScience,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIScience.Controller.UIScienceCtrl"),
  View = require("UI.UIScience.View.UIScienceView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWScience/UIScience.prefab"
}
return {UIScience = UIScience}
