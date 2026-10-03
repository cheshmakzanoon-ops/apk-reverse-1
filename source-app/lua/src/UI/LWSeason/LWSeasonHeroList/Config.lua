local UILWSeasonHeroList = {
  Name = UIWindowNames.UILWSeasonHeroList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonHeroList.Controller.LWSeasonHeroListCtrl"),
  View = require("UI.LWSeason.LWSeasonHeroList.View.LWSeasonHeroListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonHeroList.prefab"
}
return {UILWSeasonHeroList = UILWSeasonHeroList}
