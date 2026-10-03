local UIEpidemicBattleSkillPointCtrl = BaseClass("UIEpidemicBattleSkillPointCtrl", UIBaseCtrl)

function UIEpidemicBattleSkillPointCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEpidemicBattleSkillPoint)
end

return UIEpidemicBattleSkillPointCtrl
