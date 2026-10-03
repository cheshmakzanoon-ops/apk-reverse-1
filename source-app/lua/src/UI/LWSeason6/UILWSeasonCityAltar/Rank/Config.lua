local UILWS6CityAltarSkillRank = {
  Name = UIWindowNames.UILWS6CityAltarSkillRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.UILWSeasonCityAltar.Rank.Ctrl.UILWS6CityAltarSkillRankCtrl"),
  View = require("UI.LWSeason6.UILWSeasonCityAltar.Rank.View.UILWS6CityAltarSkillRankView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/CityAltar/S6CityAltarSkillRank.prefab"
}
return {UILWS6CityAltarSkillRank = UILWS6CityAltarSkillRank}
