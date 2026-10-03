local UIHeadTalk = {
  Name = UIWindowNames.UIHeadTalk,
  Layer = UILayer.Guide,
  Ctrl = require("UI.UIHeadTalk.Controller.UIHeadTalkCtrl"),
  View = require("UI.UIHeadTalk.View.UIHeadTalkView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UIHeadTalk.prefab"
}
return {UIHeadTalk = UIHeadTalk}
