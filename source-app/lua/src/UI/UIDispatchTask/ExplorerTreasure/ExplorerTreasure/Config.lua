local UIExplorerTreasure = {
  Name = UIWindowNames.UIExplorerTreasure,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.ExplorerTreasure.ExplorerTreasure.Controller.UIExplorerTreasureCtrl"),
  View = require("UI.UIDispatchTask.ExplorerTreasure.ExplorerTreasure.View.UIExplorerTreasureView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ExplorerTreasure/UIExplorerTreasure.prefab"
}
return {UIExplorerTreasure = UIExplorerTreasure}
