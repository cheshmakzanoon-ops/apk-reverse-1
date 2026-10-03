local UIServerNotice = {
  Name = UIWindowNames.UIServerNotice,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISetting.UIServerNotice.Controller.UIServerNoticeCtrl"),
  View = require("UI.UISetting.UIServerNotice.View.UIServerNoticeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIServerNotice/UIServerNotice.prefab"
}
return {UIServerNotice = UIServerNotice}
