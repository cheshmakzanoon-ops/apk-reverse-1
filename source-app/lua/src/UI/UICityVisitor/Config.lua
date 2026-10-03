local UICityVisitor = {
  Name = UIWindowNames.UICityVisitor,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICityVisitor.Controller.UICityVisitorCtrl"),
  View = require("UI.UICityVisitor.View.UICityVisitorView"),
  PrefabPath = "Assets/Main/Prefabs/UI/CityVisitor/UICityVisitor.prefab"
}
return {UICityVisitor = UICityVisitor}
