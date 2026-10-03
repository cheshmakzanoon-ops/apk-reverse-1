local UIMainNotice = {
  Name = UIWindowNames.UIMainNotice,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMainNotice.Controller.UIMainNoticeCtrl"),
  View = require("UI.UIMainNotice.View.UIMainNoticeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMainNotice/UIMainNotice.prefab"
}
return {UIMainNotice = UIMainNotice}
