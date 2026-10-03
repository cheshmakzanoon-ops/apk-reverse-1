local UITCCardSkillTipCtrl = BaseClass("UITCCardSkillTipCtrl", UIBaseCtrl)

function UITCCardSkillTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITCCardSkillTip)
end

return UITCCardSkillTipCtrl
