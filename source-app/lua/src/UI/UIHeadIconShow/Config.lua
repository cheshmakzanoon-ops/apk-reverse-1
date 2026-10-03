local UIHeadIconShow = {
  Name = UIWindowNames.UIHeadIconShow,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHeadIconShow.Controller.UIHeadIconShowCtrl"),
  View = require("UI.UIHeadIconShow.View.UIHeadIconShowView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/UIHeadIconShow.prefab"
}
return {UIHeadIconShow = UIHeadIconShow}
