local UILWSeason4Center = {
  Name = UIWindowNames.UILWSeason4Center,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason4.MilitaryCenterS4.LWSeason4MilitaryCenter.Controller.UILWSeason4MilitaryCenterCtrl"),
  View = require("UI.LWSeason4.MilitaryCenterS4.LWSeason4MilitaryCenter.View.UILWSeason4MilitaryCenterView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/UIMilitaryCenter/SeasonMilitaryCenter.prefab",
  HideBack = true
}
return {UILWSeason4Center = UILWSeason4Center}
