local UIBookMark = {
  Name = UIWindowNames.UIBookMark,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBookMark.Controller.UIBookMarkCtrl"),
  View = require("UI.UIBookMark.View.UIBookMarkView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BookMark/UIBookMark.prefab"
}
return {UIBookMark = UIBookMark}
