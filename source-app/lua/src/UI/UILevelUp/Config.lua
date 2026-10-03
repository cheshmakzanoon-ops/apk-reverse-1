local UILevelUp = {
  Name = UIWindowNames.UILevelUp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILevelUp.Controller.UILevelUpCtrl"),
  View = require("UI.UILevelUp.View.UILevelUpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILevelUp/UILevelUp.prefab"
}
return {UILevelUp = UILevelUp}
