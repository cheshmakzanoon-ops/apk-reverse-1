local UIExplorerTreasureIntroduce = {
  Name = UIWindowNames.UIExplorerTreasureIntroduce,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.ExplorerTreasure.Introduce.Ctrl.UIExplorerTreasureIntroduceCtrl"),
  View = require("UI.UIDispatchTask.ExplorerTreasure.Introduce.View.UIExplorerTreasureIntroduceView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ExplorerTreasure/UIExplorerTreasureIntroduce.prefab"
}
return {UIExplorerTreasureIntroduce = UIExplorerTreasureIntroduce}
