local UIPasture = {
  Name = UIWindowNames.UIPasture,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPasture.Controller.UIPastureCtrl"),
  View = require("UI.UIPasture.View.UIPastureView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFarm/UIPasture.prefab"
}
return {UIPasture = UIPasture}
