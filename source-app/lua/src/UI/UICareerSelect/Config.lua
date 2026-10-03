local UICareerSelect = {
  Name = UIWindowNames.UICareerSelect,
  Layer = UILayer.Background,
  Ctrl = require("UI.UICareerSelect.Controller.UICareerSelectCtrl"),
  View = require("UI.UICareerSelect.View.UICareerSelectView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPlayerLevel/UICareerSelect.prefab"
}
return {UICareerSelect = UICareerSelect}
