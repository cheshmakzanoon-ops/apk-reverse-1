local UIMailAllUserHeroesView = {
  Name = UIWindowNames.UIMailAllUserHeroesView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMailNew.UIMailAllUserHeroesView.Controller.UIMailAllUserHeroesCtrl"),
  View = require("UI.UIMailNew.UIMailAllUserHeroesView.View.UIMailAllUserHeroesView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Mail/UserHeroList/UIMailAllUserHeros.prefab"
}
return {UIMailAllUserHeroesView = UIMailAllUserHeroesView}
