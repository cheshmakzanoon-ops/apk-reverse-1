local LWActMeteoriteRankAward = {
  Name = UIWindowNames.LWActMeteoriteRankAward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWActMeteorite.Controller.LWActMeteoriteRankAwardCtrl"),
  View = require("UI.LWActMeteorite.View.LWActMeteoriteRankAwardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIActMeteorite/LWUIActMeteoriteRankAward.prefab"
}
return {LWActMeteoriteRankAward = LWActMeteoriteRankAward}
