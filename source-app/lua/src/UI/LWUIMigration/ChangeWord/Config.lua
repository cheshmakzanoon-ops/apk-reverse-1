local LWUIMigrationChangeWord = {
  Name = UIWindowNames.LWUIMigrationChangeWord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMigration.ChangeWord.Controller.LWUIMigrationChangeWordCtrl"),
  View = require("UI.LWUIMigration.ChangeWord.View.LWUIMigrationChangeWordView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigrationChangeWord.prefab"
}
return {LWUIMigrationScore = LWUIMigrationChangeWord}
