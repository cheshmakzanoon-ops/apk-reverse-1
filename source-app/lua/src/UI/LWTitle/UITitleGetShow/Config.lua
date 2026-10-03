local UITitleGetShow = {
  Name = UIWindowNames.UITitleGetShow,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWTitle.UITitleGetShow.UITitleGetShowCtrl"),
  View = require("UI.LWTitle.UITitleGetShow.UITitleGetShowView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWTitle/UITitleGetShow.prefab"
}
return {UITitleGetShow = UITitleGetShow}
