local UIFarmGather = {
  Name = UIWindowNames.UIFarmGather,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFarmIrrigate.Controller.UIFarmIrrigateCtrl"),
  View = require("UI.UIFarmIrrigate.View.UIFarmIrrigateView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFarm/UIFarmIrrigate.prefab"
}
return {UIFarmGather = UIFarmGather}
