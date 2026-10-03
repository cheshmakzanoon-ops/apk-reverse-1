local T11SoldierSkillTipCtrl = BaseClass("T11SoldierSkillTipCtrl", UIBaseCtrl)

function T11SoldierSkillTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.T11SoldierSkillTip)
end

return T11SoldierSkillTipCtrl
