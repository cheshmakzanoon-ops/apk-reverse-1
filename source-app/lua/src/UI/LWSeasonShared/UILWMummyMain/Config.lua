local UILWMummyMain = {
  Name = UIWindowNames.UILWMummyMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeasonShared.UILWMummyMain.Controller.UILWMummyMainCtrl"),
  View = require("UI.LWSeasonShared.UILWMummyMain.View.UILWMummyMainView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/UIMummyMain/UIMummyMain.prefab"
}
return {UILWMummyMain = UILWMummyMain}
