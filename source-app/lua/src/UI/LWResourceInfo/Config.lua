local UILWResourceInfo = {
  Name = UIWindowNames.UILWResourceInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWResourceInfo.Controller.LWUIResourceInfoCtrl"),
  View = require("UI.LWResourceInfo.View.LWUIResourceInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWResource/LWResourceInfo.prefab"
}
return {UILWResourceInfo = UILWResourceInfo}
