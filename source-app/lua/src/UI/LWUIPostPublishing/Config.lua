local LWUIMasterySkillUse = {
  Name = UIWindowNames.LWUIPostPublishing,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIPostPublishing.Controller.LWUIPostPublishingCtrl"),
  View = require("UI.LWUIPostPublishing.View.LWUIPostPublishingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/ChatNotice/LWUIPostPublishing.prefab"
}
return {LWUIMasterySkillUse = LWUIMasterySkillUse}
