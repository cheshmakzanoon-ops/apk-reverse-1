local LWActMeteoriteFlyTip = {
  Name = UIWindowNames.LWActMeteoriteFlyTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWActMeteorite.Controller.LWActMeteoriteFlyTipCtrl"),
  View = require("UI.LWActMeteorite.View.LWActMeteoriteFlyTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIActMeteorite/LWUIActMeteoriteFlyTip.prefab"
}
return {LWActMeteoriteFlyTip = LWActMeteoriteFlyTip}
