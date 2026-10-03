local UICampEffectOverviewPreview = {
  Name = UIWindowNames.UICampEffectOverviewPreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeasonShared.UICampEffectOverviewPreview.Controller.UICampEffectOverviewPreviewCtrl"),
  View = require("UI.LWSeasonShared.UICampEffectOverviewPreview.View.UICampEffectOverviewPreviewView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/CampScience/UICampEffectOverviewPreview.prefab"
}
return {UICampEffectOverviewPreview = UICampEffectOverviewPreview}
