local UIMultiBuyV2 = {
  Name = UIWindowNames.UIMultiBuyV2,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMultiBuyV2.Controller.UIMultiBuyV2Ctrl"),
  View = require("UI.UIMultiBuyV2.View.UIMultiBuyV2View"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWBlackMarket/UIMultiBuyV2.prefab"
}
return {UIMultiBuyV2 = UIMultiBuyV2}
