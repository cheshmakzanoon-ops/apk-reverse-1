local UILWCityBuffSource = {
  Name = UIWindowNames.UILWCityBuffSource,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWCityBuffSource.Controller.UILWCityBuffSourceCtrl"),
  View = require("UI.UILWCityBuffSource.View.UILWCityBuffSourceView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/UILWCityBuffSource.prefab"
}
return {UILWCityBuffSource = UILWCityBuffSource}
