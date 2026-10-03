local UICampEffectOverview = {
  Name = UIWindowNames.UICampEffectOverview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeasonShared.UICampEffectOverview.Controller.UICampEffectOverviewCtrl"),
  View = require("UI.LWSeasonShared.UICampEffectOverview.View.UICampEffectOverviewView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/CampScience/UICampEffectOverview.prefab"
}
return {UICampEffectOverview = UICampEffectOverview}
