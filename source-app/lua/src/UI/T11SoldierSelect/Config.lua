local T11SoldierSelect = {
  Name = UIWindowNames.T11SoldierSelect,
  Layer = UILayer.Normal,
  Ctrl = require("UI.T11SoldierSelect.Ctrl.T11SoldierSelectCtrl"),
  View = require("UI.T11SoldierSelect.View.T11SoldierSelectView"),
  PrefabPath = "Assets/Main/Prefabs/UI/T11/T11SoldierSelect/T11SoldierSelect.prefab"
}
return {T11SoldierSelect = T11SoldierSelect}
