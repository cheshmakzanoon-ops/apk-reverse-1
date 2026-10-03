local UILLBuff = {
  Name = UIWindowNames.UILLBuff,
  Layer = UILayer.Normal,
  Ctrl = require("UI.Landlord.Buff.Ctrl.UILLBuffCtrl"),
  View = require("UI.Landlord.Buff.View.UILLBuffView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Landlord/LLBuffPanel.prefab"
}
return {UILLBuff = UILLBuff}
