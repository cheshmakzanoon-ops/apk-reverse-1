local UISceneNoInput = {
  Name = UIWindowNames.UINoInput,
  Layer = UILayer.Scene,
  Ctrl = require("UI.UISceneNoInput.Controller.UISceneNoInputCtrl"),
  View = require("UI.UISceneNoInput.View.UISceneNoInputView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UINoInput.prefab"
}
return {UISceneNoInput = UISceneNoInput}
