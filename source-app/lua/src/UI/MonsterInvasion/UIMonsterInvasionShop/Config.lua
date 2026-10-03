local LWUIMonsterInvasionShop = {
  Name = UIWindowNames.LWUIMonsterInvasionShop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.MonsterInvasion.UIMonsterInvasionShop.Controller.UIMonsterInvasionShopCtrl"),
  View = require("UI.MonsterInvasion.UIMonsterInvasionShop.View.UIMonsterInvasionShopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/MonsterInvasion/LWUIMonsterInvasionShopView.prefab"
}
return {LWUIMonsterInvasionShop = LWUIMonsterInvasionShop}
