local UILWUserPrompt = {
  Name = UIWindowNames.UILWUserPrompt,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUserPrompt.Controller.UILWUserPromptCtrl"),
  View = require("UI.LWUserPrompt.View.UILWUserPromptView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UserPrompt.prefab"
}
return {UILWUserPrompt = UILWUserPrompt}
