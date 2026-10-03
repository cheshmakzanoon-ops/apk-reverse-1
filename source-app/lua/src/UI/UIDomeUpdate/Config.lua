local UIDomeUpdate = {
  Name = UIWindowNames.UIDomeUpdate,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIDomeUpdate.Controller.UIDomeUpdateCtrl"),
  View = require("UI.UIDomeUpdate.View.UIDomeUpdateView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuildUpgrade/UIDomeUpdate.prefab"
}
return {UIDomeUpdate = UIDomeUpdate}
