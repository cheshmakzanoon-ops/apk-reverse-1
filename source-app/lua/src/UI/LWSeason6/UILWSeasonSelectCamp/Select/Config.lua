local S6SelectCampSelectView = {
  Name = UIWindowNames.S6SelectCampSelectView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.UILWSeasonSelectCamp.Select.Ctrl.S6SelectCampSelectCtrl"),
  View = require("UI.LWSeason6.UILWSeasonSelectCamp.Select.View.S6SelectCampSelectView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/SelectCamp/S6SelectCampSelect.prefab"
}
return {S6SelectCampSelectView = S6SelectCampSelectView}
