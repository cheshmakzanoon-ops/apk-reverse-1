local LWUIActEasterEggChat = {
  Name = UIWindowNames.LWUIActEasterEggChat,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActEasterEgg.LWUIActEasterEggChat.Controller.LWUIActEasterEggChatCtrl"),
  View = require("UI.LWUIActEasterEgg.LWUIActEasterEggChat.View.LWUIActEasterEggChatView"),
  PrefabPath = "Assets/Main/ActivityRes/2025EasterMod/Prefabs/UI/LWUIActEasterEggChat/LWUIActEasterEggChat.prefab"
}
return {LWUIActEasterEggChat = LWUIActEasterEggChat}
