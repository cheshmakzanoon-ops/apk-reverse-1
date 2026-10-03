local UILWSeasonMilitaryCenterCondition = {
  Name = UIWindowNames.UILWSeasonMilitaryCenterCondition,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason3.MilitaryCenter.LWSeasonMilitaryCenterCondition.Controller.UILWSeasonMilitaryCenterConditionCtrl"),
  View = require("UI.LWSeason3.MilitaryCenter.LWSeasonMilitaryCenterCondition.View.UILWSeasonMilitaryCenterConditionView"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/UIMilitaryCenter/SeasonMilitaryCenterCondition.prefab"
}
return {UILWSeasonMilitaryCenterCondition = UILWSeasonMilitaryCenterCondition}
