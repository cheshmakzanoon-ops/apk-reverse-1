local UIGuideHeadTalk = {
  Name = UIWindowNames.UIGuideHeadTalk,
  Layer = UILayer.Guide,
  Ctrl = require("UI.UIGuideHeadTalk.Controller.UIGuideHeadTalkCtrl"),
  View = require("UI.UIGuideHeadTalk.View.UIGuideHeadTalkView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UIGuideHeadTalk.prefab"
}
return {UIGuideHeadTalk = UIGuideHeadTalk}
