local UIChatAISetting = {
  Name = UIWindowNames.UIChatAISetting,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChatAI.UIChatAISetting.Controller.UIChatAISettingCtrl"),
  View = require("UI.UIChatAI.UIChatAISetting.View.UIChatAISettingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/ChatAI/UIChatAISetting.prefab"
}
return {UIChatAISetting = UIChatAISetting}
