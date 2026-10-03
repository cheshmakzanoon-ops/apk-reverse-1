local UIAlCompeteCross = {
  Name = UIWindowNames.UIAlCompeteCross,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlCompeteCross.Controller.UIAlCompeteCrossCtrl"),
  View = require("UI.UIAlCompeteCross.View.UIAlCompeteCrossView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllianceCompeteNew/UIAlCompeteCross.prefab"
}
return {UIAlCompeteCross = UIAlCompeteCross}
