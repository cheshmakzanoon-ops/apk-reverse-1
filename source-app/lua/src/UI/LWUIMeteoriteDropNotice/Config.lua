local LWUIMeteoriteDropNoticeNotice = {
  Name = UIWindowNames.LWUIMeteoriteDropNoticeNotice,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMeteoriteDropNotice.Controller.LWUIMeteoriteDropNoticeCtrl"),
  View = require("UI.LWUIMeteoriteDropNotice.View.LWUIMeteoriteDropNoticeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIMeteorite/LWUIMeteoriteDropNotice.prefab"
}
return {LWUIMeteoriteDropNoticeNotice = LWUIMeteoriteDropNoticeNotice}
