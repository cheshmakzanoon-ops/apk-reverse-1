local UIChampionDuelGroupList = {
  Name = UIWindowNames.UIChampionDuelGroupList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionDuel.GroupList.Controller.UIChampionDuelGroupListCtrl"),
  View = require("UI.UIChampionDuel.GroupList.View.UIChampionDuelGroupListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelGroupList.prefab"
}
return {UIChampionDuelGroupList = UIChampionDuelGroupList}
