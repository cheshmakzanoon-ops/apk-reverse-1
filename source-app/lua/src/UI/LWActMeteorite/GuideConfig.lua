local LWActMeteoriteGuide = {
  Name = UIWindowNames.LWActMeteoriteGuide,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWActMeteorite.Controller.LWActMeteoriteGuideCtrl"),
  View = require("UI.LWActMeteorite.View.LWActMeteoriteGuideView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIActMeteorite/LWUIActMeteoriteGuide.prefab"
}
return {LWActMeteoriteGuide = LWActMeteoriteGuide}
