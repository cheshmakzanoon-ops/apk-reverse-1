local UITitleMain = {
  Name = UIWindowNames.UITitleMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWTitle.UITitleMain.UITitleMainCtrl"),
  View = require("UI.LWTitle.UITitleMain.UITitleMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWTitle/UITitleMain.prefab"
}
return {UITitleMain = UITitleMain}
