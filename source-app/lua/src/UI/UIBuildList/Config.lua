local UIBuildList = {
  Name = UIWindowNames.UIBuildList,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIBuildList.Controller.UIBuildListCtrl"),
  View = require("UI.UIBuildList.View.UIBuildListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuildUpgrade/UIBuildList_LW.prefab"
}
return {UIBuildList = UIBuildList}
