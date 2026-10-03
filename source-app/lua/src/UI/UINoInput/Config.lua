local UINoInput = {
  Name = UIWindowNames.UINoInput,
  Layer = UILayer.Dialog,
  Ctrl = require("UI.UINoInput.Controller.UINoInputCtrl"),
  View = require("UI.UINoInput.View.UINoInputView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UINoInput.prefab"
}
return {UINoInput = UINoInput}
