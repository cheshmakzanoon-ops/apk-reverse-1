local UINewKing = {
  Name = UIWindowNames.UINewKing,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.KingBattle.UINewKing.UINewKingCtrl"),
  View = require("UI.LWSeason5.KingBattle.UINewKing.UINewKingView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/KingBattle/UINewKing.prefab"
}
return {UINewKing = UINewKing}
