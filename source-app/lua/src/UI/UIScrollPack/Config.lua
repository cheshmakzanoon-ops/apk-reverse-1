local UIScrollPack = {
  Name = UIWindowNames.UIScrollPack,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIScrollPack.Controller.UIScrollPackCtrl"),
  View = require("UI.UIScrollPack.View.UIScrollPackView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIScrollPack/UIScrollPack.prefab"
}
return {UIScrollPack = UIScrollPack}
