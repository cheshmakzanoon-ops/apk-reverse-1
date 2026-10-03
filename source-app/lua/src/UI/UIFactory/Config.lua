local UIFactory = {
  Name = UIWindowNames.UIFactory,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIFactory.Controller.UIFactoryCtrl"),
  View = require("UI.UIFactory.View.UIFactoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFactory/UIFactory.prefab"
}
return {UIFactory = UIFactory}
