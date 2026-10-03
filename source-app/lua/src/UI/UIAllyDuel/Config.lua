local UIAllyDuel = {
  Name = UIWindowNames.UIAllyDuel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllyDuel.Controller.UIAllyDuelCtrl"),
  View = require("UI.UIAllyDuel.View.UIAllyDuelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllyDuel/UIAllyDuel.prefab",
  HideBack = true
}
return {UIAllyDuel = UIAllyDuel}
