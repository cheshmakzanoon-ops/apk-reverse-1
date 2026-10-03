local LWActMeteoriteGenNotice = {
  Name = UIWindowNames.LWUIMeteoriteGenNoticeNotice,
  Layer = UILayer.Info,
  Ctrl = require("UI.LWActMeteorite.Controller.LWActMeteoriteGenNoticeCtrl"),
  View = require("UI.LWActMeteorite.View.LWActMeteoriteGenNoticeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIActMeteorite/LWUIActMeteoriteGenNotice.prefab"
}
return {LWActMeteoriteGenNotice = LWActMeteoriteGenNotice}
