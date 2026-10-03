local UISkirmishResult = {
  Name = UIWindowNames.UISkirmishResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISkirmish.Result.Controller.UISkirmishResultCtrl"),
  View = require("UI.UISkirmish.Result.View.UISkirmishResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Skirmish/UISkirmishResult.prefab"
}
return {UISkirmishMain = UISkirmishResult}
