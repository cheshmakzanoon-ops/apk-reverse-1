local UICapacityAdd = {
  Name = UIWindowNames.UICapacityAdd,
  Layer = UILayer.Dialog,
  Ctrl = require("UI.UICapacityAdd.Controller.UICapacityAddCtrl"),
  View = require("UI.UICapacityAdd.View.UICapacityAddView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMain/UICapacityAdd.prefab"
}
return {UICapacityAdd = UICapacityAdd}
