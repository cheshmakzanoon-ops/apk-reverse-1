local UICapacityBoxSelect = {
  Name = UIWindowNames.UICapacityBoxSelect,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICapacityBoxSelect.Controller.UICapacityBoxSelectCtrl"),
  View = require("UI.UICapacityBoxSelect.View.UICapacityBoxSelectView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWBag/UICapacityBoxSelect.prefab"
}
return {UICapacityBoxSelect = UICapacityBoxSelect}
