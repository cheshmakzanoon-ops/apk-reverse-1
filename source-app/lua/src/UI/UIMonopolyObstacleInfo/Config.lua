local UIMineCaveUnlock = {
  Name = UIWindowNames.UIMonopolyObstacleInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMonopolyObstacleInfo.Controller.UIMonopolyObstacleInfoCtrl"),
  View = require("UI.UIMonopolyObstacleInfo.View.UIMonopolyObstacleInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Monopoly/UIMonopolyObstacleInfo.prefab"
}
return {UIMineCaveUnlock = UIMineCaveUnlock}
