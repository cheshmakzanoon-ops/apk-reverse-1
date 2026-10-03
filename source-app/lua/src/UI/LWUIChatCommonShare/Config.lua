local LWUIMasterySkillUse = {
  Name = UIWindowNames.LWUIChatCommonShare,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIChatCommonShare.Controller.LWUIChatCommonShareCtrl"),
  View = require("UI.LWUIChatCommonShare.View.LWUIChatCommonShareView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/ChatCommonShare/ChatCommonShare.prefab"
}
return {LWUIMasterySkillUse = LWUIMasterySkillUse}
