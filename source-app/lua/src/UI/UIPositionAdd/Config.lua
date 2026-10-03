local UIPositionAdd = {
  Name = UIWindowNames.UIPositionAdd,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPositionAdd.Controller.UIPositionAddCtrl"),
  View = require("UI.UIPositionAdd.View.UIPositionAddView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIPositionAdd.prefab"
}
return {UIPositionAdd = UIPositionAdd}
