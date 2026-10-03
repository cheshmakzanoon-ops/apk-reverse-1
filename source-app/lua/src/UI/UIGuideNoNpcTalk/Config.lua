local UIGuideNoNpcTalk = {
  Name = UIWindowNames.UIHeroEntrust,
  Layer = UILayer.Guide,
  Ctrl = require("UI.UIGuideNoNpcTalk.Controller.UIGuideNoNpcTalkCtrl"),
  View = require("UI.UIGuideNoNpcTalk.View.UIGuideNoNpcTalkView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UIGuideNoNpcTalk.prefab"
}
return {UIGuideNoNpcTalk = UIGuideNoNpcTalk}
