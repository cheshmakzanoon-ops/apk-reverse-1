local UIBloodyNightStageList = {
  Name = UIWindowNames.UIBloodyNightStageList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBloodyNight.UIBloodyNightStageList.UIBloodyNightStageListCtrl"),
  View = require("UI.UIBloodyNight.UIBloodyNightStageList.UIBloodyNightStageListView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Activity/BloodyNight/UIBloodyNightStageList.prefab"
}
return {UIBloodyNightStageList = UIBloodyNightStageList}
