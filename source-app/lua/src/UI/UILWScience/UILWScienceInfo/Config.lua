local UILWScienceInfo = {
  Name = UIWindowNames.UILWScienceInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWScience.UILWScienceInfo.Controller.UILWScienceInfoCtrl"),
  View = require("UI.UILWScience.UILWScienceInfo.View.UILWScienceInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWScience/UILWScienceInfo.prefab"
}
return {UILWScienceInfo = UILWScienceInfo}
