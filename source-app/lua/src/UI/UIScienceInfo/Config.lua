local UIScienceInfo = {
  Name = UIWindowNames.UIScienceInfo,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIScienceInfo.Controller.UIScienceInfoCtrl"),
  View = require("UI.UIScienceInfo.View.UIScienceInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWScience/UIScienceInfo.prefab"
}
return {UIScienceInfo = UIScienceInfo}
