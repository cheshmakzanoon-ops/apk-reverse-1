local SeasonHunterBattle = {
  Name = UIWindowNames.SeasonHunterBattle,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonHunter.SeasonHunterBattle.SeasonHunterBattleCtrl"),
  View = require("UI.LWSeason.LWSeasonHunter.SeasonHunterBattle.SeasonHunterBattleView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Hunter/SeasonHunterBattle.prefab"
}
return {SeasonHunterBattle = SeasonHunterBattle}
