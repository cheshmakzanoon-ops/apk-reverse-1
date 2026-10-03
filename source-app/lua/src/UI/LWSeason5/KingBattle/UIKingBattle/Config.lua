local UIKingBattle = {
  Name = UIWindowNames.UIKingBattle,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.KingBattle.UIKingBattle.UIKingBattleCtrl"),
  View = require("UI.LWSeason5.KingBattle.UIKingBattle.UIKingBattleView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/KingBattle/UIKingBattle.prefab"
}
return {UIKingBattle = UIKingBattle}
