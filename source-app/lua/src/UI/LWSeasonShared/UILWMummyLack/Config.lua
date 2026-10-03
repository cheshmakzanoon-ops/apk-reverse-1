local UILWMummyLack = {
  Name = UIWindowNames.UILWMummyLack,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeasonShared.UILWMummyLack.Controller.UILWMummyLackCtrl"),
  View = require("UI.LWSeasonShared.UILWMummyLack.View.UILWMummyLackView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/UIMummyMain/UIMummyLack.prefab"
}
return {UILWMummyLack = UILWMummyLack}
