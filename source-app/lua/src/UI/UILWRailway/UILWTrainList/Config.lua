local UILWTrainList = {
  Name = UIWindowNames.UILWTrainList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UILWTrainList.Controller.UILWTrainListCtrl"),
  View = require("UI.UILWRailway.UILWTrainList.View.UILWTrainListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/UILWTrainList.prefab"
}
return {UILWTrainList = UILWTrainList}
