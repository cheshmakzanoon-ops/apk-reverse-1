local UIWorkerOverviewList = {
  Name = UIWindowNames.UIWorkerOverviewList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWWorker.UIWorkerOverviewList.Controller.UIWorkerOverviewListCtrl"),
  View = require("UI.UILWWorker.UIWorkerOverviewList.View.UIWorkerOverviewListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIWorker/UIWorkerOverviewListPanel.prefab",
  HideBack = true
}
return {UIWorkerOverviewList = UIWorkerOverviewList}
