local UILeagueMatchResult = {
  Name = UIWindowNames.UILeagueMatchResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LeagueMatch.UILeagueMatchResult.Controller.UILeagueMatchResultCtrl"),
  View = require("UI.LeagueMatch.UILeagueMatchResult.View.UILeagueMatchResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LeagueMatch/UILeagueMatchResult/UILeagueMatchResult.prefab"
}
return {UILeagueMatchResult = UILeagueMatchResult}
