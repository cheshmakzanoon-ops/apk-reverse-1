local UILWDominatorMain = {
  Name = UIWindowNames.UILWDominatorMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWDominator.Main.Ctrl.UILWDominatorMainCtrl"),
  View = require("UI.UILWDominator.Main.View.UILWDominatorMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorMain.prefab",
  HideBack = true
}
return {UILWDominatorMain = UILWDominatorMain}
