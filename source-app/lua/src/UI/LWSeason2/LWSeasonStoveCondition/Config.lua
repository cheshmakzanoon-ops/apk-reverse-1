local UILWSeasonStoveCondition = {
  Name = UIWindowNames.UILWSeasonStoveCondition,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason2.LWSeasonStoveCondition.Controller.UILWSeasonStoveConditionCtrl"),
  View = require("UI.LWSeason2.LWSeasonStoveCondition.View.UILWSeasonStoveConditionView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason2/SeasonStoveCondition.prefab"
}
return {UILWSeasonStoveCondition = UILWSeasonStoveCondition}
