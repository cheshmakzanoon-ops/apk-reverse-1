local MoveCityConfig = {
  Name = UIWindowNames.LWActMeteoriteMoveCity,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWActMeteorite.Controller.LWActMeteoriteMoveCityCtrl"),
  View = require("UI.LWActMeteorite.View.LWUIActMeteoriteMoveCityView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIActMeteorite/LWUIActMeteoriteMoveCityView.prefab"
}
return {MoveCityConfig = MoveCityConfig}
