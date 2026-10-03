local LWUIMasteryGetSkill = {
  Name = UIWindowNames.LWUIMasteryGetSkill,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMasteryGetSkill.Controller.LWUIMasteryGetSkillCtrl"),
  View = require("UI.LWUIMasteryGetSkill.View.LWUIMasteryGetSkillView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMastery/LWUIMasteryGetSkill.prefab"
}
return {LWUIMasteryGetSkill = LWUIMasteryGetSkill}
