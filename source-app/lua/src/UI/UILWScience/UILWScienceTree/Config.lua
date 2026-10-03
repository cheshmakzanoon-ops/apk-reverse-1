local UILWScienceTree = {
  Name = UIWindowNames.UILWScienceTree,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWScience.UILWScienceTree.Controller.UILWScienceTreeCtrl"),
  View = require("UI.UILWScience.UILWScienceTree.View.UILWScienceTreeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWScience/UILWScienceTree.prefab",
  HideBack = true
}
return {UILWScienceTree = UILWScienceTree}
