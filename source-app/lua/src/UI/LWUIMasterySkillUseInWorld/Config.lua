local LWUIMasterySkillUseInWorld = {
  Name = UIWindowNames.LWUIMasterySkillUseInWorld,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMasterySkillUseInWorld.Controller.LWUIMasterySkillUseInWorldCtrl"),
  View = require("UI.LWUIMasterySkillUseInWorld.View.LWUISkillUseInWorldView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMastery/LWUISkillUseInWorld.prefab"
}
return {LWUIMasterySkillUseInWorld = LWUIMasterySkillUseInWorld}
