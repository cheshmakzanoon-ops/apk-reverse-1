local LWUISkillUseInChat = {
  Name = UIWindowNames.LWUISkillUseInChat,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUISkillUseInChat.Controller.LWUISkillUseInChatCtrl"),
  View = require("UI.LWUISkillUseInChat.View.LWUISkillUseInChatView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMastery/LWUISkillUseInChat.prefab"
}
return {LWUISkillUseInChat = LWUISkillUseInChat}
