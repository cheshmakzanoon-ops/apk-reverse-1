local UIResourceLackNew = {
  Name = UIWindowNames.UIResourceLackNew,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIResourceLackNew.Controller.UIResourceLackNewCtrl"),
  View = require("UI.UIResourceLackNew.View.UIResourceLackNewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIResource/UIResourceLackNew.prefab"
}
return {UIResourceLackNew = UIResourceLackNew}
