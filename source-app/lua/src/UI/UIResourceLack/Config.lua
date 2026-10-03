local UIResourceLack = {
  Name = UIWindowNames.UIResourceLack,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIResourceLack.Controller.UIResourceLackCtrl"),
  View = require("UI.UIResourceLack.View.UIResourceLackView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIResource/UIResourceLackView.prefab"
}
return {UIResourceLack = UIResourceLack}
