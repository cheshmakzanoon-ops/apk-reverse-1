local UILWDominatorArchive = {
  Name = UIWindowNames.UILWDominatorArchive,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWDominator.Archive.Ctrl.UILWDominatorArchiveCtrl"),
  View = require("UI.UILWDominator.Archive.View.UILWDominatorArchiveView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorArchive.prefab"
}
return {UILWDominatorArchive = UILWDominatorArchive}
