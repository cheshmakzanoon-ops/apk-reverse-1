local LWSeasonAwards = {
  Name = UIWindowNames.UILWSeasonAwards,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonAwards.Controller.LWSeasonAwardsCtrl"),
  View = require("UI.LWSeason.LWSeasonAwards.View.LWSeasonAwardsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/SeasonAwards/UILWSeasonAwards.prefab",
  HideBack = true
}
return {LWSeasonAwards = LWSeasonAwards}
