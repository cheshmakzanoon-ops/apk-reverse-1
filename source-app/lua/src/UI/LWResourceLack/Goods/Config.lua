local UILWGoodsLack = {
  Name = UIWindowNames.UILWGoodsLack,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWResourceLack.Goods.Controller.LWUIGoodsLackCtrl"),
  View = require("UI.LWResourceLack.Goods.View.LWUIGoodsLackView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWResource/LWGoodLack.prefab"
}
return {UILWGoodsLack = UILWGoodsLack}
