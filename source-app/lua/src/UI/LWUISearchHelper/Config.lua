local LWUISearchHelper = {
  Name = UIWindowNames.LWUISearchHelper,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUISearchHelper.Controller.LWUISearchHelperCtrl"),
  View = require("UI.LWUISearchHelper.View.LWUISearchHelperView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUISearchHelper/LWUISearchHelper.prefab"
}
return {LWUISearchHelper = LWUISearchHelper}
