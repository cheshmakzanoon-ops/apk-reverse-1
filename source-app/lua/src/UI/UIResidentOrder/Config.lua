local UIResidentOrder = {
  Name = UIWindowNames.UIResidentOrder,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIResidentOrder.Controller.UIResidentOrderCtrl"),
  View = require("UI.UIResidentOrder.View.UIResidentOrderView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIResidentOrder/UIResidentOrder.prefab"
}
return {UIResidentOrder = UIResidentOrder}
