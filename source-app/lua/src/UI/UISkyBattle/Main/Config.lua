local SkyBattleMain = {
  Name = UIWindowNames.SkyBattleMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISkyBattle.Main.SkyBattleMainCtrl"),
  View = require("UI.UISkyBattle.Main.SkyBattleMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SkyBattle/SkyBattleMain.prefab"
}
return {SkyBattleMain = SkyBattleMain}
