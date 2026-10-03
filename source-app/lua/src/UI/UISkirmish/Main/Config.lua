local UISkirmishMain = {
  Name = UIWindowNames.UISkirmishMain,
  Layer = UILayer.Background,
  Ctrl = require("UI.UISkirmish.Main.Controller.UISkirmishMainCtrl"),
  View = require("UI.UISkirmish.Main.View.UISkirmishMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Skirmish/UISkirmishMain.prefab"
}
return {UISkirmishMain = UISkirmishMain}
