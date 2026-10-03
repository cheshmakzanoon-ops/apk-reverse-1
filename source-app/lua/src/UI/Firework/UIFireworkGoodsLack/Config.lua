local UIFireworkGoodsLack = {
  Name = UIWindowNames.UIFireworkGoodsLack,
  Layer = UILayer.Normal,
  Ctrl = require("UI.Firework.UIFireworkGoodsLack.Controller.UIFireworkGoodsLackCtrl"),
  View = require("UI.Firework.UIFireworkGoodsLack.View.UIFireworkGoodsLackView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIFirework/UIFireworkGoodLack.prefab"
}
return {UIFireworkGoodsLack = UIFireworkGoodsLack}
