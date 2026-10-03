local UILeagueMatchAlliances = {
  Name = UIWindowNames.UILeagueMatchAlliances,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LeagueMatch.UILeagueMatchAlliances.Controller.UILeagueMatchAlliancesCtrl"),
  View = require("UI.LeagueMatch.UILeagueMatchAlliances.View.UILeagueMatchAlliancesView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LeagueMatch/UILeagueMatchAlliances/UILeagueMatchAlliances.prefab"
}
return {UILeagueMatchAlliances = UILeagueMatchAlliances}
