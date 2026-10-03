local UIBattlePassBuy = {
  Name = UIWindowNames.UIBattlePassBuy,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBattlePassBuy.Controller.UIBattlePassBuyCtrl"),
  View = require("UI.UIBattlePassBuy.View.UIBattlePassBuyView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/BattlePass/UIBattlePassBuy.prefab"
}
return {UIBattlePassBuy = UIBattlePassBuy}
