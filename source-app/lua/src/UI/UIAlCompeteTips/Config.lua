local UIAlCompeteTips = {
  Name = UIWindowNames.UIAlCompeteTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlCompeteTips.Controller.UIAlCompeteTipsCtrl"),
  View = require("UI.UIAlCompeteTips.View.UIAlCompeteTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllianceCompeteNew/UIAlCompeteTips.prefab"
}
return {UIAlCompeteTips = UIAlCompeteTips}
