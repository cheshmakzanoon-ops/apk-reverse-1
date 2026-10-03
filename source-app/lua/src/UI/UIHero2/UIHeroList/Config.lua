local UIHeroList = {
  Name = UIWindowNames.UIHeroList,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIHero2.UIHeroList.Controller.UIHeroListCtrl"),
  View = require("UI.UIHero2.UIHeroList.View.UIHeroListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroList.prefab",
  HideBack = true
}
return {UIHeroList = UIHeroList}
