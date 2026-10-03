local UILLBattleSkillDetail = {
  Name = UIWindowNames.UILLBattleSkillDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LandlordBattle.BattleSkillDetail.Controller.UILLBattleSkillDetailCtrl"),
  View = require("UI.LandlordBattle.BattleSkillDetail.View.UILLBattleSkillDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Landlord/World/LLBattleSkill.prefab"
}
return {UILLBattleSkillDetail = UILLBattleSkillDetail}
