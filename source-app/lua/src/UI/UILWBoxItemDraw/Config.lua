local UILWBoxItemDraw = {
  Name = UIWindowNames.UILWBoxItemDraw,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWBoxItemDraw.Ctrl.UILWBoxItemDrawCtrl"),
  View = require("UI.UILWBoxItemDraw.View.UILWBoxItemDrawView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWBag/UILWBoxItemDraw.prefab"
}
return {UILWBoxItemDraw = UILWBoxItemDraw}
