local UIAllianceCommonSkillSelectCtrl = BaseClass("UIAllianceCommonSkillSelectCtrl", UIBaseCtrl)

function UIAllianceCommonSkillSelectCtrl:CloseSelf(useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceCommonSkillSelect, {anim = useAnimation})
end

return UIAllianceCommonSkillSelectCtrl
