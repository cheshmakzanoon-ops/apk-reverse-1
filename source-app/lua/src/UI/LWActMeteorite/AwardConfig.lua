local LWActMeteoriteAward = {
  Name = UIWindowNames.LWActMeteoriteAward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWActMeteorite.Controller.LWActMeteoriteAwardCtrl"),
  View = require("UI.LWActMeteorite.View.LWActMeteoriteAwardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIActMeteorite/LWUIActMeteoriteAward.prefab"
}
return {LWActMeteoriteAward = LWActMeteoriteAward}
