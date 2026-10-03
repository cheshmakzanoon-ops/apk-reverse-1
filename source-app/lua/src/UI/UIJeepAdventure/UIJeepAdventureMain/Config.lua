local UIJeepAdventureMain = {
  Name = UIWindowNames.UIJeepAdventureMain,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIJeepAdventure.UIJeepAdventureMain.Controller.UIJeepAdventureMainCtrl"),
  View = require("UI.UIJeepAdventure.UIJeepAdventureMain.View.UIJeepAdventureMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIJeepAdventure/UIJeepAdventureMain.prefab",
  HideBack = true,
  HideSceneCamera = true,
  CustomKeyCodeEscape = true
}
return {UIJeepAdventureMain = UIJeepAdventureMain}
