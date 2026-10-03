local S6SelectCampIntroView = {
  Name = UIWindowNames.S6SelectCampIntroView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.UILWSeasonSelectCamp.Intro.Controller.S6SelectCampIntroCtrl"),
  View = require("UI.LWSeason6.UILWSeasonSelectCamp.Intro.View.S6SelectCampIntroView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/SelectCamp/S6SelectCampIntro.prefab"
}
return {S6SelectCampIntroView = S6SelectCampIntroView}
