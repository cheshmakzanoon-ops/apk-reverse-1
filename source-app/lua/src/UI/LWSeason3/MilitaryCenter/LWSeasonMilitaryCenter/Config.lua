local UILWSeasonMilitaryCenter = {
  Name = UIWindowNames.UILWSeasonMilitaryCenter,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason3.MilitaryCenter.LWSeasonMilitaryCenter.Controller.UILWSeasonMilitaryCenterCtrl"),
  View = require("UI.LWSeason3.MilitaryCenter.LWSeasonMilitaryCenter.View.UILWSeasonMilitaryCenterView"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/UIMilitaryCenter/SeasonMilitaryCenter.prefab",
  HideBack = true
}
return {UILWSeasonMilitaryCenter = UILWSeasonMilitaryCenter}
