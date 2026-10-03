local RankChangeConfig = {
  Name = UIWindowNames.LWUIActMeteoriteRankChangedNotice,
  Layer = UILayer.Background,
  Ctrl = require("UI.LWActMeteorite.Controller.LWActMeteoriteRankChangeCtrl"),
  View = require("UI.LWActMeteorite.View.LWUIActMeteoriteRankChangedNoticeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIActMeteorite/LWUIActMeteoriteRankChangedNotice.prefab"
}
return {RankChangeConfig = RankChangeConfig}
