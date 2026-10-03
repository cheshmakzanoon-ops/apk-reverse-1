local UIAllyDrillSelect = {
  Name = UIWindowNames.UIAllyDrillSelect,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllyDrill.UIAllyDrillSelect.Controller.UIAllyDrillSelectCtrl"),
  View = require("UI.UIAllyDrill.UIAllyDrillSelect.View.UIAllyDrillSelectView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/AllyDrill/UIAllyDrillSelect.prefab"
}
return {UIAllyDrillSelect = UIAllyDrillSelect}
