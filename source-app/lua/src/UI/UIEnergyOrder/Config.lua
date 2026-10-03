local UIEnergyOrder = {
  Name = UIWindowNames.UIEnergyOrder,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIEnergyOrder.Controller.UIEnergyOrderCtrl"),
  View = require("UI.UIEnergyOrder.View.UIEnergyOrderView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIEnergyOrder/UIEnergyOrder.prefab"
}
return {UIEnergyOrder = UIEnergyOrder}
