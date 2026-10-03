local T11UnlockNewSkillCtrl = BaseClass("T11UnlockNewSkillCtrl", UIBaseCtrl)

function T11UnlockNewSkillCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.T11UnlockNewSkill)
end

function T11UnlockNewSkillCtrl:GetUnlockSkillData()
  return T11Util.GetCurStageSkillData()
end

return T11UnlockNewSkillCtrl
