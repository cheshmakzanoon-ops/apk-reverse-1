local LimitedTimeFeastNotice = {
  Name = UIWindowNames.LimitedTimeFeastNotice,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LimitedTimeFeastNotice.Controller.LimitedTimeFeastNoticeCtrl"),
  View = require("UI.LimitedTimeFeastNotice.View.LimitedTimeFeastNoticeViewNew"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/LimitedTimeFeast/LimitedTimeFeastNoticeNew.prefab"
}
return {LimitedTimeFeastNotice = LimitedTimeFeastNotice}
