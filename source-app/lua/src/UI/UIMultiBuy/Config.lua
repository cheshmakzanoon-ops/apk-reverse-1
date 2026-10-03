local UIMultiBuy = {
  Name = UIWindowNames.UIMultiBuy,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMultiBuy.Controller.UIMultiBuyCtrl"),
  View = require("UI.UIMultiBuy.View.UIMultiBuyView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICommonShop/UIMultiBuy.prefab"
}
return {UIMultiBuy = UIMultiBuy}
