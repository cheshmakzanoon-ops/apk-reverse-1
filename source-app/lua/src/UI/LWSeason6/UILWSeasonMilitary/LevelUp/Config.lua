local S6MilitaryLevelUp = {
  Name = UIWindowNames.S6MilitaryLevelUp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.UILWSeasonMilitary.LevelUp.Ctrl.S6MilitaryLevelUpCtrl"),
  View = require("UI.LWSeason6.UILWSeasonMilitary.LevelUp.View.S6MilitaryLevelUpView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/Military/S6MilitaryLevelUp.prefab",
  HideBack = true
}
return {S6MilitaryLevelUp = S6MilitaryLevelUp}
