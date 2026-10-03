local UIWorkerListPanel = {
  Name = UIWindowNames.UIWorkerList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWWorker.UIWorkerListPanel.Controller.UIWorkerListPanelCtrl"),
  View = require("UI.UILWWorker.UIWorkerListPanel.View.UIWorkerListPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIWorkerListPanel.prefab"
}
return {UIWorkerListPanel = UIWorkerListPanel}
