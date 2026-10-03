local UIResourceBag = {
  Name = UIWindowNames.UIResourceBag,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIResourceBag.Controller.UIResourceBagCtrl"),
  View = require("UI.UIResourceBag.View.UIResourceBagView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIResource/UIResourceBag.prefab"
}
return {UIResourceBag = UIResourceBag}
