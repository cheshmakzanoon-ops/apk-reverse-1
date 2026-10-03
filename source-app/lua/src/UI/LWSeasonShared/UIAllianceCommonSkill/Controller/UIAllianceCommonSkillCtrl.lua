local UIAllianceCommonSkillCtrl = BaseClass("UIAllianceCommonSkillCtrl", UIBaseCtrl)

function UIAllianceCommonSkillCtrl:CloseSelf(useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceCommonSkill, {anim = useAnimation})
end

return UIAllianceCommonSkillCtrl
