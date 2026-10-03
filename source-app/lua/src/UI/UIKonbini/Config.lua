local UIKonbini = {
  Name = UIWindowNames.UIKonbini,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIKonbini.Controller.UIKonbiniCtrl"),
  View = require("UI.UIKonbini.View.UIKonbiniView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIKonbini/UIKonbini.prefab"
}
return {UIKonbini = UIKonbini}
