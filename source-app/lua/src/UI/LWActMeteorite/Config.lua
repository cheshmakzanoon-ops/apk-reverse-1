local LWActMeteoriteMain = {
  Name = UIWindowNames.LWActMeteoriteMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWActMeteorite.Controller.LWActMeteoriteMainCtrl"),
  View = require("UI.LWActMeteorite.View.LWActMeteoriteMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIActMeteorite/LWUIActMeteoriteMain.prefab",
  HideBack = true
}
return {LWActMeteoriteMain = LWActMeteoriteMain}
