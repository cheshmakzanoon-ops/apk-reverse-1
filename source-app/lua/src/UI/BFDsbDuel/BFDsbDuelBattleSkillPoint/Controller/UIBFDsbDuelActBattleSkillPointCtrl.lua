local UIBFDsbDuelActBattleSkillPointCtrl = BaseClass("UIBFDsbDuelActBattleSkillPointCtrl", UIBaseCtrl)

function UIBFDsbDuelActBattleSkillPointCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBFDsbDuelActBattleSkillPoint)
end

return UIBFDsbDuelActBattleSkillPointCtrl
