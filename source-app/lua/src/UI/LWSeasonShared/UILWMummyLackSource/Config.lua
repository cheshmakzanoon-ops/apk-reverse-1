local UILWMummyLackSource = {
  Name = UIWindowNames.UILWMummyLackSource,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeasonShared.UILWMummyLackSource.Controller.UILWMummyLackSourceCtrl"),
  View = require("UI.LWSeasonShared.UILWMummyLackSource.View.UILWMummyLackSourceView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/UIMummyMain/UIMummyLackSource.prefab"
}
return {UILWMummyLackSource = UILWMummyLackSource}
