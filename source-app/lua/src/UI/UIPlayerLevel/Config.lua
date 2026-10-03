local UIPlayerLevel = {
  Name = UIWindowNames.UIPlayerLevel,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIPlayerLevel.Controller.UIPlayerLevelCtrl"),
  View = require("UI.UIPlayerLevel.View.UIPlayerLevelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPlayerLevel/UIPlayerLevel.prefab"
}
return {UIPlayerLevel = UIPlayerLevel}
