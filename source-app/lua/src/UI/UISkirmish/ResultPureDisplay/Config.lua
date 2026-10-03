local UILWPureDisplaySkirmishResult = {
  Name = UIWindowNames.UILWPureDisplaySkirmishResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISkirmish.ResultPureDisplay.Controller.UILWPureDisplaySkirmishResultCtrl"),
  View = require("UI.UISkirmish.ResultPureDisplay.View.UILWPureDisplaySkirmishResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Skirmish/UILWPureDisplaySkirmishResult.prefab"
}
return {UILWPureDisplaySkirmishResult = UILWPureDisplaySkirmishResult}
