local UIAlLeaderCandidates = {
  Name = UIWindowNames.UIAlLeaderCandidates,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAlLeaderCandidates.Controller.UIAlLeaderCandidatesCtrl"),
  View = require("UI.UIAlliance.UIAlLeaderCandidates.View.UIAlLeaderCandidatesView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAlLeaderCandidates.prefab"
}
return {UIAlLeaderCandidates = UIAlLeaderCandidates}
