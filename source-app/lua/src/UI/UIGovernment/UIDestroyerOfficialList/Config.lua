local UIDestroyerOfficialList = {
  Name = UIWindowNames.UIDestroyerOfficialList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.UIDestroyerOfficialList.UIDestroyerOfficialListCtrl"),
  View = require("UI.UIGovernment.UIDestroyerOfficialList.UIDestroyerOfficialListView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/Official/UIDestroyerOfficialList.prefab",
  HideBack = true
}
return {UIDestroyerOfficialList = UIDestroyerOfficialList}
