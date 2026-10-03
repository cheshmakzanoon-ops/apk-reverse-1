local UIAllianceCommonSkillUseTipCtrl = BaseClass("UIAllianceCommonSkillUseTipCtrl", UIBaseCtrl)

function UIAllianceCommonSkillUseTipCtrl:CloseSelf(useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceCommonSkillUseTip, {anim = useAnimation})
end

return UIAllianceCommonSkillUseTipCtrl
