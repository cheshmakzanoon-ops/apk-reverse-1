local UIBuildHeroList = {
  Name = UIWindowNames.UIBuildHeroList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBuildHeroList.Controller.UIBuildHeroLisCtrl"),
  View = require("UI.UIBuildHeroList.View.UIBuildHeroListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuildDispatching/UIBuildHeroList.prefab"
}
return {UIBuildList = UIBuildHeroList}
