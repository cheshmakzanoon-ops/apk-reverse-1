local UIChatAIEmojiPopup = {
  Name = UIWindowNames.UIChatAIEmojiPopup,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIChatAI.UIChatAIEmojiPopup.Controller.UIChatAIEmojiPopupController"),
  View = require("UI.UIChatAI.UIChatAIEmojiPopup.View.UIChatAIEmojiPopupView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/ChatAI/UIChatAIEmojiPopup.prefab"
}
return {UIChatAIEmojiPopup = UIChatAIEmojiPopup}
