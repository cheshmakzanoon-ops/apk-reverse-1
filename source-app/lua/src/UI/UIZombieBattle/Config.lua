local UIZombieBattleMain = {
  Name = UIWindowNames.UIZombieBattleMain,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIZombieBattle.Controller.UIZombieBattleMainCtrl"),
  View = require("UI.UIZombieBattle.View.UIZombieBattleMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ZombieBattle/UIZombieBattleMain.prefab"
}
return {UIZombieBattleMain = UIZombieBattleMain}
