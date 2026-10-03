local UIBFDsbDuelActBattleSkillPoint = {
  Name = UIWindowNames.UIBFDsbDuelActBattleSkillPoint,
  Layer = UILayer.Normal,
  Ctrl = require("UI.BFDsbDuel.BFDsbDuelBattleSkillPoint.Controller.UIBFDsbDuelActBattleSkillPointCtrl"),
  View = require("UI.BFDsbDuel.BFDsbDuelBattleSkillPoint.View.UIBFDsbDuelActBattleSkillPointView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/BattleSkillPoint/BattleSkillPoint.prefab"
}
return {UIBFDsbDuelActBattleSkillPoint = UIBFDsbDuelActBattleSkillPoint}
