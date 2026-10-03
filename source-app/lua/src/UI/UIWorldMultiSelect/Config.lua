local UIWorldMultiSelect = {
  Name = UIWindowNames.UIWorldMultiSelect,
  Layer = UILayer.TopMost,
  Ctrl = require("UI.UIWorldMultiSelect.Controller.UIWorldMultiSelectCtrl"),
  View = require("UI.UIWorldMultiSelect.View.UIWorldMultiSelectView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWWorld/UIWorldMultiSelect.prefab"
}
return {UIWorldMultiSelect = UIWorldMultiSelect}
