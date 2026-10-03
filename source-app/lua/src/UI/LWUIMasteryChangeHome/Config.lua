local LWUIMasteryChangeHome = {
  Name = UIWindowNames.LWUIMasteryChangeHome,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMasteryChangeHome.Controller.LWUIMasteryChangeHomeCtrl"),
  View = require("UI.LWUIMasteryChangeHome.View.LWUIMasteryChangeHomeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMastery/LWUIMasteryChangeHome.prefab"
}
return {LWUIMasteryChangeHome = LWUIMasteryChangeHome}
