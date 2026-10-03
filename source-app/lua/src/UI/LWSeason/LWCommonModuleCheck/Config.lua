local LWCommonModuleCheck = {
  Name = UIWindowNames.LWCommonModuleCheck,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWCommonModuleCheck.Controller.LWCommonModuleCheckCtrl"),
  View = require("UI.LWSeason.LWCommonModuleCheck.View.LWCommonModuleCheckView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/LWCommonModuleCheck.prefab"
}
return {LWCommonModuleCheck = LWCommonModuleCheck}
