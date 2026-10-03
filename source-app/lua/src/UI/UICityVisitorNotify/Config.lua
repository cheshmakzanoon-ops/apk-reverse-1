local UICityVisitor = {
  Name = UIWindowNames.UICityVisitorNotify,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICityVisitorNotify.Controller.UICityVisitorNotifyCtrl"),
  View = require("UI.UICityVisitorNotify.View.UICityVisitorNotifyView"),
  PrefabPath = "Assets/Main/Prefabs/UI/CityVisitor/UICityVisitorNotify.prefab"
}
return {UICityVisitor = UICityVisitor}
