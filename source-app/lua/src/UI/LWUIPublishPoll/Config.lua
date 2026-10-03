local LWUIPublishPoll = {
  Name = UIWindowNames.LWUIPublishPoll,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIPublishPoll.Controller.LWUIPublishPollCtrl"),
  View = require("UI.LWUIPublishPoll.View.LWUIPublishPollView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/ChatNotice/LWUIPublishPoll.prefab"
}
return {LWUIPublishPoll = LWUIPublishPoll}
