local UIAllianceScienceInfo = {
  Name = UIWindowNames.UIAllianceScienceInfo,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIAlliance.UIAllianceScienceInfo.Controller.UIAllianceScienceInfoCtrl"),
  View = require("UI.UIAlliance.UIAllianceScienceInfo.View.UIAllianceScienceInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceScienceInfo.prefab"
}
return {UIAllianceScienceInfo = UIAllianceScienceInfo}
