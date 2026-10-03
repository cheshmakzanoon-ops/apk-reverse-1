local UICapacityFull = {
  Name = UIWindowNames.UICapacityFull,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICapacityFull.Controller.UICapacityFullCtrl"),
  View = require("UI.UICapacityFull.View.UICapacityFullView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICapacity/UICapacityFull.prefab"
}
return {UICapacityFull = UICapacityFull}
