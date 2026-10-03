local UIEpidemicBattleSkillCtrl = BaseClass("UIEpidemicBattleSkillCtrl", UIBaseCtrl)

function UIEpidemicBattleSkillCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEpidemicBattleSkill)
end

return UIEpidemicBattleSkillCtrl
