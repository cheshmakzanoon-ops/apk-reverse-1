local CampSelectList = {
  Name = UIWindowNames.CampSelectList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonCampWar.CampSelectList.CampSelectListCtrl"),
  View = require("UI.LWSeason.LWSeasonCampWar.CampSelectList.CampSelectListView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/CampSelection/CampSelectList.prefab"
}
return {CampSelectList = CampSelectList}
