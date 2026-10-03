local UICareerLevelUp = {
  Name = UIWindowNames.UICareerLevelUp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICareerLevelUp.Controller.UICareerLevelUpCtrl"),
  View = require("UI.UICareerLevelUp.View.UICareerLevelUpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICareerLevelUp/UICareerLevelUp.prefab"
}
return {UICareerLevelUp = UICareerLevelUp}
