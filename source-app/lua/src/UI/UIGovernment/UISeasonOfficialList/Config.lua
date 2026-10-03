local UISeasonOfficialList = {
  Name = UIWindowNames.UISeasonOfficialList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.UISeasonOfficialList.UISeasonOfficialListCtrl"),
  View = require("UI.UIGovernment.UISeasonOfficialList.UISeasonOfficialListView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/Official/UISeasonOfficialList.prefab",
  HideBack = true
}
return {UISeasonOfficialList = UISeasonOfficialList}
