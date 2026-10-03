local UISurfingBattleMain = {
  Name = UIWindowNames.UISurfingBattleMain,
  Layer = UILayer.Background,
  Ctrl = require("UI.UISurfing.Inside.Main.Controller.UISurfingBattleMainCtrl"),
  View = require("UI.UISurfing.Inside.Main.View.UISurfingBattleMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SurfingBattle/Inside/UISurfingBattleMain.prefab"
}
return {UISurfingBattleMain = UISurfingBattleMain}
