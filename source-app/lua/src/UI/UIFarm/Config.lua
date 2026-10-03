local UIFarm = {
  Name = UIWindowNames.UIFarm,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIFarm.Controller.UIFarmNewCtrl"),
  View = require("UI.UIFarm.View.UIFarmNewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFarm/UIFarmNew.prefab"
}
return {UIFarm = UIFarm}
