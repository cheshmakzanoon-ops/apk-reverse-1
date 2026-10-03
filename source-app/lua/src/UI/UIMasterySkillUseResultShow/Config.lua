local UIMasterySkillUseResultShow = {
  Name = UIWindowNames.UIMasterySkillUseResultShow,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIMasterySkillUseResultShow.Controller.UIMasterySkillUseResultShowCtrl"),
  View = require("UI.UIMasterySkillUseResultShow.View.UIMasterySkillUseResultShowView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMastery/UIMasterySkillUseResultShow.prefab"
}
return {UIMasterySkillUseResultShow = UIMasterySkillUseResultShow}
