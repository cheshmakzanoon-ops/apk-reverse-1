local UILeagueMatchReward = {
  Name = UIWindowNames.UILeagueMatchReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LeagueMatch.UILeagueMatchReward.Controller.UILeagueMatchRewardCtrl"),
  View = require("UI.LeagueMatch.UILeagueMatchReward.View.UILeagueMatchRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LeagueMatch/UILeagueMatchReward/UILeagueMatchReward.prefab"
}
return {UILeagueMatchReward = UILeagueMatchReward}
