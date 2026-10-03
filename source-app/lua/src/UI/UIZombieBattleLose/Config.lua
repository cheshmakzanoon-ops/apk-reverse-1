local UIZombieBattleLose = {
  Name = UIWindowNames.UIZombieBattleLose,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIZombieBattleLose.Controller.UIZombieBattleLoseCtrl"),
  View = require("UI.UIZombieBattleLose.View.UIZombieBattleLoseView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWStage/LWBattleLosePanel.prefab"
}
return {UIZombieBattleLose = UIZombieBattleLose}
