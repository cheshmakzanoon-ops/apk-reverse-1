local UIEpidemicBattleSkillRecordCtrl = BaseClass("UIEpidemicBattleSkillRecordCtrl", UIBaseCtrl)

function UIEpidemicBattleSkillRecordCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEpidemicBattleSkillRecord)
end

return UIEpidemicBattleSkillRecordCtrl
