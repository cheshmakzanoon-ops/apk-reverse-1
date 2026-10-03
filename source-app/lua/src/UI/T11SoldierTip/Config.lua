local T11SoldierSkillTip = {
  Name = UIWindowNames.T11SoldierSkillTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.T11SoldierTip.Ctrl.T11SoldierSkillTipCtrl"),
  View = require("UI.T11SoldierTip.View.T11SoldierSkillTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/T11/T11Common/T11SoldierSkillTip.prefab"
}
return {T11SoldierSkillTip = T11SoldierSkillTip}
