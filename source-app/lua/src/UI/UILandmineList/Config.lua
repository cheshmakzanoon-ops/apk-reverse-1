local UILandmineList = {
  Name = UIWindowNames.UILandmineList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILandmineList.Controller.UILandmineListCtrl"),
  View = require("UI.UILandmineList.View.UILandmineListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILandmineList/UILandmineList.prefab"
}
return {UILandmineList = UILandmineList}
