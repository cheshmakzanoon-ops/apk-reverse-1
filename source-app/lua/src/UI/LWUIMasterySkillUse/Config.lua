local LWUIMasterySkillUse = {
  Name = UIWindowNames.LWUIMasterySkillUse,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMasterySkillUse.Controller.LWUIMasterySkillUseCtrl"),
  View = require("UI.LWUIMasterySkillUse.View.LWUIMasterySkillUseView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMastery/LWUIMasterySkillUse.prefab"
}
return {LWUIMasterySkillUse = LWUIMasterySkillUse}
