local UIResourceCost = {
  Name = UIWindowNames.UIResourceCost,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIResourceCost.Controller.UIResourceCostCtrl"),
  View = require("UI.UIResourceCost.View.UIResourceCostView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UITransportRes/UIResourceCostPanel.prefab"
}
return {UIResourceCost = UIResourceCost}
