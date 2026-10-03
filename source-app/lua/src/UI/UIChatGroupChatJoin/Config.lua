local UIChatGroupChatJoin = {
  Name = UIWindowNames.UIChatGroupChatJoin,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChatGroupChatJoin.Ctrl.UIChatGroupChatJoinCtrl"),
  View = require("UI.UIChatGroupChatJoin.View.UIChatGroupChatJoinView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/GroupChat/UIChatGroupChatJoin.prefab"
}
return {UIChatGroupChatJoin = UIChatGroupChatJoin}
