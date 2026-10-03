local UIGuideCommunicationTalk = {
  Name = UIWindowNames.UIGuideCommunicationTalk,
  Layer = UILayer.Guide,
  Ctrl = require("UI.UIGuideCommunicationTalk.Controller.UIGuideCommunicationTalkCtrl"),
  View = require("UI.UIGuideCommunicationTalk.View.UIGuideCommunicationTalkView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UIGuideCommunicationTalk.prefab"
}
return {UIGuideCommunicationTalk = UIGuideCommunicationTalk}
