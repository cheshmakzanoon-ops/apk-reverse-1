local UILWBlackMarketProbab = {
  Name = UIWindowNames.UILWBlackMarketProbab,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWBlackMarketProbab.Controller.UILWBlackMarketProbabCtrl"),
  View = require("UI.UILWBlackMarketProbab.View.UILWBlackMarketProbabView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWBlackMarket/UILWBlackMarketProbab.prefab"
}
return {UILWBlackMarketProbab = UILWBlackMarketProbab}
