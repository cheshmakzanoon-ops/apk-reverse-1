local UILWTeamLeaderSelectCoin = {
  Name = UIWindowNames.UILWTeamLeaderSelectCoin,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason3.UILWFactionSelection.UILWTeamLeaderSelectCoin.Controller.UILWTeamLeaderSelectCoinCtrl"),
  View = require("UI.LWSeason3.UILWFactionSelection.UILWTeamLeaderSelectCoin.View.UILWTeamLeaderSelectCoinView"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/FactionSelection/TeamLeaderSelectCoin.prefab"
}
return {UILWTeamLeaderSelectCoin = UILWTeamLeaderSelectCoin}
