local UIAlLeaderVote = {
  Name = UIWindowNames.UIAlLeaderVote,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAlLeaderVote.Controller.UIAlLeaderVoteCtrl"),
  View = require("UI.UIAlliance.UIAlLeaderVote.View.UIAlLeaderVoteView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAlLeaderVote.prefab"
}
return {UIAlLeaderVote = UIAlLeaderVote}
