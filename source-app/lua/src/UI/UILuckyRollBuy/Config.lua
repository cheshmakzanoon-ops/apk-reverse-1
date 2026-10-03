local UILuckyRollBuy = {
  Name = UIWindowNames.UILuckyRollBuy,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILuckyRollBuy.Controller.UILuckyRollBuyCtrl"),
  View = require("UI.UILuckyRollBuy.View.UILuckyRollBuyView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/LuckyRoll/UILuckyRollBuy.prefab"
}
return {UILuckyRollBuy = UILuckyRollBuy}
