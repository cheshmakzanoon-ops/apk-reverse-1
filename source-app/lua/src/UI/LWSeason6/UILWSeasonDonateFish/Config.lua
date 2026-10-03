local UILWSeasonDonateFish = {
  Name = UIWindowNames.UILWSeasonDonateFish,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.UILWSeasonDonateFish.Controller.UILWSeasonDonateFishCtrl"),
  View = require("UI.LWSeason6.UILWSeasonDonateFish.View.UILWSeasonDonateFishView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/DonateFish/UISeasonDonateFish.prefab"
}
return {UILWSeasonDonateFish = UILWSeasonDonateFish}
