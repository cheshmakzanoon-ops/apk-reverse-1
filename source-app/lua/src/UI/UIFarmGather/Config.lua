local UIFarmGather = {
  Name = UIWindowNames.UIFarmGather,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFarmGather.Controller.UIFarmGatherCtrl"),
  View = require("UI.UIFarmGather.View.UIFarmGatherView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFarm/UIFarmGather.prefab"
}
return {UIFarmGather = UIFarmGather}
