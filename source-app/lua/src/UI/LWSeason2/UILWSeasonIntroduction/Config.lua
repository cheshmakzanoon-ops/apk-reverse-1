local UILWSeasonIntroduction = {
  Name = UIWindowNames.UILWSeasonIntroduction,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason2.UILWSeasonIntroduction.Controller.UILWSeasonIntroductionCtrl"),
  View = require("UI.LWSeason2.UILWSeasonIntroduction.View.UILWSeasonIntroductionView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeasonShared/SeasonIntroduction.prefab"
}
return {UILWSeasonIntroduction = UILWSeasonIntroduction}
