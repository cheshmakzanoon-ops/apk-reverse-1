local UIBookMarkAdd = {
  Name = UIWindowNames.UIBookMarkAdd,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBookMarkAdd.Controller.UIBookMarkAddCtrl"),
  View = require("UI.UIBookMarkAdd.View.UIBookMarkAddView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BookMark/UIBookMarkAdd.prefab"
}
return {UIBookMarkAdd = UIBookMarkAdd}
